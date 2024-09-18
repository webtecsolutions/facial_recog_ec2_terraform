#!/bin/bash

# Update packages
sudo apt-get update

# List block devices
lsblk

# Check if the device is unformatted
if sudo file -s /dev/nvme1n1 | awk '{print $2}' | grep -q "^data$"; then
  echo "Device is unformatted, proceeding with formatting..."
  sudo mkfs -t xfs /dev/nvme1n1
else
  echo "Device is already formatted, skipping format step."
fi

# Create mount directory
sudo mkdir -p /data

# Change permissions to make the /data directory writable for all users
sudo chmod 777 /data

# Mount the device
sudo mount /dev/nvme1n1 /data

# Extract the UUID of the device
UUID=$(sudo blkid -s UUID -o value /dev/nvme1n1)
echo "UUID of the device is $UUID"

# Backup the current fstab file
sudo cp /etc/fstab /etc/fstab.bak

# Append the new entry to fstab
echo "UUID=$UUID  /data  xfs  defaults,nofail  0  2" | sudo tee -a /etc/fstab

# Mount all filesystems mentioned in fstab
sudo mount -a

# sudo umount /data