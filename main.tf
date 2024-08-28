module "ecr_repository" {
  source              = "./modules/ecr"
  repo_name           = var.repo_name
  aws_account_id      = var.aws_account_id
  aws_region          = var.aws_region
  force_image_rebuild = var.force_image_rebuild
  dkr_img_src_path    = var.docker_img_src_path
}

module "ec2_instance" {
  source        = "./modules/ec2"
  instance_type = var.instance_type
  ami_id        = var.ami_id
  key_name      = var.key_name
  file_path     = var.file_path
  ec2_instance_name = var.ec2_instance_name
}

module "s3_bucket" {
  source     = "./modules/s3"
  image_bucket_name = var.image_bucket_name
}