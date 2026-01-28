#!/bin/bash
# End-user setup method for first boot
set -e

echo "Welcome to ArttulOS! Let's finish your setup."
read -p "Enter your desired username: " USERNAME
read -s -p "Enter your desired password: " PASSWORD

echo
sudo useradd -m "$USERNAME"
echo "$USERNAME:$PASSWORD" | sudo chpasswd

echo "User $USERNAME created. You are ready to use ArttulOS!"
