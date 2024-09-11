output "ssm_account_id_arn" {
  value = aws_ssm_parameter.account_id.arn
}

output "ssm_region_arn" {
  value = aws_ssm_parameter.region.arn
}