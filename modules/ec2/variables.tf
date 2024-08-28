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