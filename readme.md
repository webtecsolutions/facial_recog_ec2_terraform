# EC2 Backend with FastAPI

This repository contains Terraform code for setting up an EC2 backend with FastAPI.

## Prerequisites
Before getting started, make sure you have the following files in your directory:
- `terraform.tfvars`: Contains the necessary variables for Terraform configuration.
- `rsa4096.pem`: SSH key pair for accessing the EC2 instance.


## Setup
#### Commands:

- `terraform init`: Initializes the Terraform working directory and downloads the necessary provider plugins.
- `terraform plan`: Generates an execution plan for Terraform, showing the changes that will be made to the infrastructure.
- `terraform apply`: Applies the changes to the infrastructure, creating or modifying resources as necessary.
- `terraform destroy`: Destroys all the resources created by Terraform, effectively tearing down the infrastructure.


## Backend Configuration
The `backend.tf` file is configured to use S3 and DynamoDB for state locking.

### S3 Bucket
The S3 bucket specified in the configuration will be used to store images.
The name of the bucket is `facial-recognition-image-bucket`

## EC2 Module
The `ec2` module contains the necessary resources for setting up the EC2 instance.
Has the `initialconfigure.sh` file that sets up the ec2 instance.
Can see the progress with ssh to ec2 and command `cat /var/log/cloud-init-output.log`

### Exposed Port
The EC2 instance exposes port 8000.

## API Documentation
Once the instance is up and running, you can access the API documentation at `http://<public_ip_of_instance>:8000/docs`.

## Deployed Region
`Sydney`

## Endpoint
POST /verify
Description: This endpoint compares two images and returns a verification result indicating whether the faces in the images match.

### Request:

- URL: http://<instance-ip>:8000/verify
- Method: POST
- Headers:
    - Body: The body should be a JSON object with the following fields:
        - img1_path (string): The relative path to the first image.
        - img2_path (string): The relative path to the second image.

`facial-recognition-image-bucket` images need stored in this bucket in root directoy

