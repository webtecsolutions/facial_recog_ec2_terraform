output "aws_ecr_repository_url" {
  value = aws_ecr_repository.facial_recognition_repository.repository_url
}

output "null_resource_id" {
  value = null_resource.build_push_dkr_img.id
}