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
docker run -d -p 8000:8000 -e OPENSEARCH_PASSWORD=$OPENSEARCH_PASSWORD -e OPENSEARCH_USERNAME=$OPENSEARCH_USERNAME -e OPENSEARCH_HOST=$OPENSEARCH_HOST ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/facial-recognition-repository:latest

