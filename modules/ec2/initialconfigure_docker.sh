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

export AWS_REGION=$(sudo aws ssm get-parameter --name region --query "Parameter.Value" --output text)
export AWS_ACCOUNT_ID=$(sudo aws ssm get-parameter --name account_id --query "Parameter.Value" --output text)

echo $AWS_ACCOUNT_ID

# Login to AWS ECR
sudo aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

# Pull and run the docker image
docker pull ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/facial-recognition-repository:latest
docker run -d -p 8000:8000 ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/facial-recognition-repository:latest


