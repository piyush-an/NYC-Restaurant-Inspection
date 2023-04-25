variable "project_id" {
  description = "Google Cloud Platform (GCP) Project ID."
  type        = string
}

variable "region" {
  description = "GCP region name."
  type        = string
}

variable "zone" {
  description = "GCP zone name."
  type        = string
}

variable "name" {
  description = "Web server name."
  type        = string
  default     = "nyc-inspection"
}

variable "machine_type" {
  description = "GCP VM instance machine type."
  type        = string
  default     = "e2-standard-4" # e2-medium e2-standard-2 e2-standard-4
}

variable "gce_ssh_user" {
  description = "the generated ssh keypair filename"
  type        = string
  default = "ubuntu"
}

variable "ssh_key_filename" {
  description = "the generated ssh keypair filename"
  type        = string
  default     = "ce"
}
