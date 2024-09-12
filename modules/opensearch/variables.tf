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
}

variable "opensearch_master_user_name" {
  description = "The name of the master user for the OpenSearch domain"
  type        = string
}

variable "aws_account_id" {
  description = "The AWS account ID"
  type        = string
}

variable "aws_region" {
  description = "The AWS region"
  type        = string
}