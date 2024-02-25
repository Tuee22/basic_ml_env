#!/bin/bash

# generated via https://chat.openai.com/share/94f1c437-9617-4f4e-a9d7-9e51a9158830




#!/bin/bash

# Set the DEBIAN_FRONTEND variable to noninteractive to suppress prompts
export DEBIAN_FRONTEND=noninteractive

# Update package lists
echo "Updating package lists..."
sudo apt-get update

# Install unattended-upgrades if not already installed
echo "Installing unattended-upgrades..."
sudo apt-get install -y unattended-upgrades

# Enable automatic updates for all packages (not just security updates)
echo "Configuring unattended-upgrades for all packages..."
sudo sed -i 's,//\("${distro_id}:${distro_codename}-updates";\),\1,' /etc/apt/apt.conf.d/50unattended-upgrades

# Configure automatic updates
echo "Enabling automatic updates..."
sudo bash -c 'cat > /etc/apt/apt.conf.d/20auto-upgrades << EOF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
EOF'

# Install needrestart to automatically handle service restarts
echo "Installing needrestart..."
sudo apt-get install -y needrestart

# Configure needrestart to automatically restart services
echo "Configuring needrestart for automatic restarts..."
sudo sed -i 's/#\$nrconf{restart} = .*/\$nrconf{restart} = "a";/' /etc/needrestart/needrestart.conf

# Upgrade packages non-interactively
echo "Upgrading packages non-interactively..."
sudo apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

# Install Docker
echo "Installing Docker..."
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Install NVIDIA Driver (replace with the specific version if required)
echo "Installing NVIDIA driver..."
sudo apt-get install -y nvidia-driver-535

# Install NVIDIA Container Toolkit
echo "Installing NVIDIA Container Toolkit..."
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker

echo "Script execution completed. Please consider rebooting your system for all changes to take effect."