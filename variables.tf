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

variable "opensearch_domain_name" {
  description = "The name of the OpenSearch domain"
  type        = string
  
}

variable "opensearch_version" {
  description = "The version of OpenSearch to use"
  type        = string
  
}

variable "opensearch_instance_type" {
  description = "The instance type to use for the OpenSearch domain"
  type        = string
  
}

variable "opensearch_instance_count" {
  description = "The number of instances to use for the OpenSearch domain"
  type        = number
  
}

variable "multi_az_with_standby_enabled" {
  description = "Whether to enable multi-AZ with standby for the OpenSearch domain"
  type        = bool
  
}

variable "opensearch_volume_size" {
  description = "The volume size to use for the OpenSearch domain"
  type        = number
  
}

variable "opensearch_master_user_password" {
  description = "The ARN of the master user for the OpenSearch domain"
  type        = string
  sensitive   = true
}

variable "opensearch_master_user_name" {
  description = "The name of the master user for the OpenSearch domain"
  type        = string
  sensitive   = true
}

variable "ebs_device_name" {
  description = "The device name to attach the EBS volume to"
  type        = string
}

variable "ebs_volume_size" {
  description = "The size of the EBS volume"
  type        = number
}

variable "aws_availability_zone" {
  description = "The AWS availability zone to deploy the EC2 instance in"
  type        = string
  
}

variable "dlm_schedule_name" {
    description = "Name of the DLM schedule"
    type        = string
}

variable "dlm_interval" {
    description = "Interval for the DLM schedule"
    type        = number
}

variable "dlm_interval_unit" {
    description = "Unit for the DLM schedule interval"
    type        = string
}

variable "dlm_retain_rule_count" {
    description = "Number of snapshots to retain"
    type        = number
}

variable "dlm_times" {
    description = "Time to take the snapshot"
    type        = string
}

variable "ebs_snapshot_id" {
    description = "ID of the EBS snapshot"
    type        = string
}