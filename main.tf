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
  image_bucket_arn = module.s3_bucket.image_s3_bucket_arn
  ssm_account_id_arn = module.ssm.ssm_account_id_arn
  ssm_region_arn = module.ssm.ssm_region_arn
  opensearch_domain_endpoint_arn = module.ssm.opensearch_domain_endpoint_arn
  opensearch_master_user_name_arn = module.ssm.opensearch_master_user_name_arn
  opensearch_master_user_password_arn = module.ssm.opensearch_master_user_password_arn
  ec2_instance_depends_on = module.ecr_repository.null_resource_id
}

module "s3_bucket" {
  source     = "./modules/s3"
  image_bucket_name = var.image_bucket_name
}

module "ssm" {
  source        = "./modules/ssm"
  aws_account_id = var.aws_account_id
  aws_region     = var.aws_region
  opensearch_master_user_password = var.opensearch_master_user_password
  opensearch_master_user_name = var.opensearch_master_user_name
  # dummy value is used to prevent creationn of ssm every time
  opensearch_domain_endpoint = length(try(module.opensearch.opensearch_domain_endpoint, [])) > 0 ? module.opensearch.opensearch_domain_endpoint : "dummy/domain/endpoint"
}

module "opensearch" {
  source = "./modules/opensearch"
  count = 0

  opensearch_domain_name = var.opensearch_domain_name
  opensearch_version = var.opensearch_version
  opensearch_instance_count = var.opensearch_instance_count
  opensearch_instance_type = var.opensearch_instance_type
  multi_az_with_standby_enabled = var.multi_az_with_standby_enabled
  opensearch_volume_size = var.opensearch_volume_size
  opensearch_master_user_password = var.opensearch_master_user_password
  opensearch_master_user_name = var.opensearch_master_user_name
  aws_account_id = var.aws_account_id
  aws_region = var.aws_region
}