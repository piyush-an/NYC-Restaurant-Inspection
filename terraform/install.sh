sudo apt update
sudo apt upgrade --yes
sudo apt install make
# Install docker using the convenience script
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker ubuntu

