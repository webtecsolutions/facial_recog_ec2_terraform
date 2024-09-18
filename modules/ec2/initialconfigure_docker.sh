#!/bin/bash

# Update and install required packages
sudo apt-get update 
sudo apt-get install docker.io -y

# Start and enable docker
sudo systemctl start docker
sudo systemctl enable docker

# Install AWS CLI
sudo snap install aws-cli --classic

# Add user to docker group
sudo usermod -a -G docker $USER
sudo chmod 777 /var/run/docker.sock

# Create environment variables and add to profile
echo export AWS_REGION=$(sudo aws ssm get-parameter --name region --query "Parameter.Value" --output text) | sudo tee -a /etc/profile
echo export AWS_ACCOUNT_ID=$(sudo aws ssm get-parameter --name account_id --query "Parameter.Value" --output text) | sudo tee -a /etc/profile
echo export OPENSEARCH_HOST=$(sudo aws ssm get-parameter --name opensearch_domain_endpoint --query "Parameter.Value" --output text) | sudo tee -a /etc/profile
echo export OPENSEARCH_USERNAME=$(sudo aws ssm get-parameter --name opensearch_master_user_name --query "Parameter.Value" --output text --with-decryption) | sudo tee -a /etc/profile
echo export OPENSEARCH_PASSWORD=$(sudo aws ssm get-parameter --name opensearch_master_user_password --query "Parameter.Value" --output text --with-decryption) | sudo tee -a /etc/profile


# Reload profile
source /etc/profile

echo $AWS_ACCOUNT_ID

# Login to AWS ECR
sudo aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

# Pull and run the docker image
docker pull ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/facial-recognition-repository:latest

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

# Start the docker container
docker run -d -v /data:/data -p 8000:8000 \
-e OPENSEARCH_PASSWORD=$OPENSEARCH_PASSWORD -e OPENSEARCH_USERNAME=$OPENSEARCH_USERNAME -e OPENSEARCH_HOST=$OPENSEARCH_HOST \
${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/facial-recognition-repository:latest

# cat /var/log/cloud-init-output.log