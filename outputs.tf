output "s3_bucket_arn" {
  value = aws_s3_bucket.terrraform-backend.arn
  description = "The ARN of the S3 bucket"
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_lock_table.name
  description = "The name of the DynamoDB table"
}

output "ec2_instance_public_ip" {
  value = module.ec2_instance.ec2_instance_public_ip
  description = "The public IP address of the EC2 instance"
}

output "image_s3_bucket_arn" {
  value = module.s3_bucket.image_s3_bucket_arn
  description = "The ARN of the S3 bucket" 
}

