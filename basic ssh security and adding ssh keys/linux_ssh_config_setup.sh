#!/bin/bash

# Check if the user has sudo privileges
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit
fi

# Change PermitRootLogin to 'no' if it is set to 'yes'
if grep -q "PermitRootLogin yes" /etc/ssh/sshd_config; then
    sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
fi

# Change PasswordAuthentication to 'no' if it is set to 'yes'
if grep -q "PasswordAuthentication yes" /etc/ssh/sshd_config; then
    sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
fi

# Go to the ~/.ssh directory
cd ~/.ssh

# Create authorized_keys file if it doesn't exist
if [ ! -f authorized_keys ]; then
    touch authorized_keys
fi

# Prompt user for public SSH key
echo "Enter your public SSH key:"
read public_key

# Verify that the provided key is not empty
if [[ -z "$public_key" ]]; then
    echo "No public SSH key provided. Aborting."
    exit 1
fi

# Add warning message
echo "WARNING: Only use your public SSH key. Using an unauthorized key may compromise security."

# Open authorized_keys file for editing
sudo nano authorized_keys

# Add the provided public key to the authorized_keys file
echo "$public_key" >> authorized_keys
