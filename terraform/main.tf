terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.53.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file("${path.module}/tfkey.json")
}

resource "google_compute_address" "static" {
  name = "ipv4-address"
}


data "google_compute_image" "ubuntu" {
  family  = "ubuntu-2004-lts"
  project = "ubuntu-os-cloud"
}

data "template_file" "install" {
  template = file("${path.module}/install.sh")
}


resource "google_compute_instance" "vm" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["web"]
  #   labels       = var.labels

  metadata = {
    ssh-keys = "${var.gce_ssh_user}:${file("${path.module}/${var.ssh_key_filename}.pub")}"
  }

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
      size  = 50
      type  = "pd-balanced"
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static.address
    }
  }

  metadata_startup_script = data.template_file.install.rendered
}

resource "google_compute_firewall" "default" {
  name    = "web-firewall"
  network = "default"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "8086", "3000", "8095"] # Change ports as required
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]
}

