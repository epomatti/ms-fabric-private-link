#!/bin/sh

export DEBIAN_FRONTEND=noninteractive

# Update
apt update
apt upgrade -y

# Install Azure CLI, used to pull the image from ACR
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Add Docker's official GPG key:
apt-get update
apt-get install -y ca-certificates
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


reboot
