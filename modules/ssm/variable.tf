variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
  
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "opensearch_master_user_password" {
  description = "OpenSearch Master User Password"
  type        = string
  sensitive  = true
}

variable "opensearch_master_user_name" {
  description = "OpenSearch Master User Name"
  type        = string
  sensitive  = true
}

variable "opensearch_domain_endpoint" {
  description = "OpenSearch Domain Endpoint"
  type        = string
}