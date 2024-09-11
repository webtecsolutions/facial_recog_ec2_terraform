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

variable "ec2_instance_name" {
  type        = string
  description = "The name of the EC2 instance"
  
}

variable "image_bucket_arn" {
  type        = string
  description = "The ARN of the S3 image bucket"
}

variable "ssm_account_id_arn" {
  type        = string
  description = "The ARN of the SSM account ID"
  
}

variable "ssm_region_arn" {
  type        = string
  description = "The region of the SSM"
}
