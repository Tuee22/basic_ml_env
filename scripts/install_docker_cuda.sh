#!/bin/bash

# generated via https://chat.openai.com/share/94f1c437-9617-4f4e-a9d7-9e51a9158830


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
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# so docker can run without sudo
sudo groupadd docker
sudo usermod -aG docker $USER

# install minikube
# Detect the architecture of the current system
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        BIN_ARCH="amd64"
        ;;
    arm64 | aarch64)
        BIN_ARCH="arm64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac
# Download the correct binary based on the architecture
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-$BIN_ARCH
# Install the binary and clean up
sudo install minikube-linux-$BIN_ARCH /usr/local/bin/minikube && rm minikube-linux-$BIN_ARCH

# install helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# install linkerd
curl --proto '=https' --tlsv1.2 -sSfL https://run.linkerd.io/install-edge | sh
# Define the folder you want to add to PATH
LINKERD_FOLDER_PATH="$HOME/.linkerd2/bin"

# Check if the PATH already contains the folder
if ! grep -q "export PATH=\$PATH:$LINKERD_FOLDER_PATH" ~/.bashrc; then
    # Add the folder to the PATH in ~/.bashrc
    echo "export PATH=\$PATH:$LINKERD_FOLDER_PATH" >> ~/.bashrc

    echo "$LINKERD_FOLDER_PATH added to PATH for this user."
else
    echo "$LINKERD_FOLDER_PATH is already in the PATH."
fi

# enable autocomplete for k
apt update
apt install -y bash-completion
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null

echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -o default -F __start_kubectl k' >>~/.bashrc

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