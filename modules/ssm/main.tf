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