resource "aws_ecr_repository" "facial_recognition_repository" {
  name                 = var.repo_name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }

}
resource "aws_ecr_lifecycle_policy" "ecr_repo_policy" {
  repository = aws_ecr_repository.facial_recognition_repository.name
  policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 14 days",
            "selection": {
                "tagStatus": "any",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 14
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

locals {
  ecr_reg   = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com" # ECR docker registry URI
  ecr_repo  = var.repo_name                                                   # ECR repo name
  image_tag = "latest"                                                        # image tag

  dkr_img_src_path   = var.dkr_img_src_path # path to the Dockerfile
  dkr_img_src_sha256 = sha256(join("", [for f in fileset(".", "${local.dkr_img_src_path}/**") : file(f)]))

  dkr_build_cmd = <<-EOT
        docker build -t ${local.ecr_reg}/${local.ecr_repo}:${local.image_tag} -f ${local.dkr_img_src_path}/Dockerfile ${local.dkr_img_src_path} && aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${local.ecr_reg} && docker push ${local.ecr_reg}/${local.ecr_repo}:${local.image_tag}
    EOT

}

# local-exec for build and push of docker image
resource "null_resource" "build_push_dkr_img" {
  triggers = {
    detect_docker_source_changes = var.force_image_rebuild == true ? timestamp() : local.dkr_img_src_sha256
  }
  provisioner "local-exec" {
    command = local.dkr_build_cmd
  }
}

output "trigged_by" {
  value = null_resource.build_push_dkr_img.triggers
}

