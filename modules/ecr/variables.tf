variable "repo_name" {
  type        = string
  description = "The name of the ECR repository"
}

variable "aws_account_id" {
  type        = string
  description = "The AWS account ID"
}

variable "aws_region" {
  type        = string
  description = "The AWS region"
}

variable "force_image_rebuild" {
  type    = bool
  default = false
}

variable "dkr_img_src_path" {
  type        = string
  description = "The path to the Dockerfile"

}