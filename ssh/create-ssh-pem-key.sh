#!/bin/bash

# use this script to generate a new ssh key pair for the current user
USERNAME=$(whoami)

openssl genrsa -out "${USERNAME}.pem" 2048
ssh-keygen -y -f "${USERNAME}.pem" > "${USERNAME}.pub"

# add public key to authorized_keys
mkdir -p ~/.ssh
cat "${USERNAME}.pub" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# enable public key authentication in sshd_config
sudo sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# restart ssh service
sudo systemctl restart sshd