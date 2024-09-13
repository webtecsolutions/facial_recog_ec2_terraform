resource "aws_ssm_parameter" "account_id" {
  name  = "account_id"
  type  = "String"
  value = var.aws_account_id

}

resource "aws_ssm_parameter" "region" {
  name  = "region"
  type  = "String"
  value = var.aws_region
}

resource "aws_ssm_parameter" "opensearch_master_user_name" {
  name  = "opensearch_master_user_name"
  type  = "SecureString"
  value = var.opensearch_master_user_name
}

resource "aws_ssm_parameter" "opensearch_master_user_password" {
  name  = "opensearch_master_user_password"
  type  = "SecureString"
  value = var.opensearch_master_user_password
}

resource "aws_ssm_parameter" "opensearch_domain_endpoint" {
  name  = "opensearch_domain_endpoint"
  type  = "String"
  value = var.opensearch_domain_endpoint
}