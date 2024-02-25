#!/bin/bash

# NB: this script was created by chat GPT from the following prompt :
# i have a vanilla ec2 instance running ubuntu 22.04 with an nvidia GPU. can you please write me a script that does the following:
#- updates all apt packages (with no user prompts)
#- installs nvidia drivers version 535
#- installs docker
#- installs whatever else is needed for nvidia containers to work properly with the gpu


# Update and Upgrade the APT packages
echo "Updating and upgrading APT packages..."
sudo apt-get update && sudo apt-get upgrade -y

# Install dependencies for adding a repository over HTTPS
echo "Installing dependencies for adding a repository over HTTPS..."
sudo apt-get install -y \
    ca-certificates \
    curl \
    software-properties-common

# Add NVIDIA package repositories
echo "Adding the NVIDIA package repositories..."
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring.gpg
sudo gpg --dearmor -o /usr/share/keyrings/cuda-archive-keyring.gpg cuda-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/cuda-archive-keyring.gpg] https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/ /" | sudo tee /etc/apt/sources.list.d/cuda.list

sudo apt-get update

# Install NVIDIA Driver version 535
echo "Installing NVIDIA Driver version 535..."
sudo apt-get install -y nvidia-driver-535

# Install Docker
echo "Installing Docker..."
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Manage Docker as a non-root user (Optional)
sudo groupadd docker
sudo usermod -aG docker $USER

# Install NVIDIA Container Toolkit
echo "Installing NVIDIA Container Toolkit..."
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker

echo "Script execution completed. Please reboot."
