output "ssm_account_id_arn" {
  value = aws_ssm_parameter.account_id.arn
}

output "ssm_region_arn" {
  value = aws_ssm_parameter.region.arn
}

output "opensearch_master_user_name_arn" {
  value = aws_ssm_parameter.opensearch_master_user_name.arn
}

output "opensearch_master_user_password_arn" {
  value = aws_ssm_parameter.opensearch_master_user_password.arn
}

output "opensearch_domain_endpoint_arn" {
  value = aws_ssm_parameter.opensearch_domain_endpoint.arn
}