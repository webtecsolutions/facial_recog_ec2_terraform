variable "project_name" {
  type        = string
  description = "The name of the project"
  default     = "facial-recognition"
}

variable "aws_account_id" {
  type        = string
  description = "The AWS account ID"
}

variable "aws_region" {
  type        = string
  description = "The AWS region"
}

variable "repo_name" {
  type        = string
  description = "The name of the ECR repository"

}

variable "docker_img_src_path" {
  type        = string
  description = "The path to the Dockerfile"
}

variable "force_image_rebuild" {
  type    = bool
  default = false
}

variable "instance_type" {
  type        = string
  description = "The instance type"
}

variable "ami_id" {
  type        = string
  description = "The AMI ID"
}

variable "key_name" {
  type        = string
  description = "The key pair name"
}

variable "file_path" {
  type        = string
  description = "The file path"
  
}

variable "image_bucket_name" {
  type        = string
  description = "The name of the S3 bucket with image"
}

variable "ec2_instance_name" {
  type        = string
  description = "The name of the EC2 instance"
  
}