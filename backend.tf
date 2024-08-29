# S3 bucket to store the terraform state file
resource "aws_s3_bucket" "terrraform-backend" {
  bucket        = "facial-recognition-terraform-backend"
}


resource "aws_s3_bucket_versioning" "versioning_terraform_backend" {
  bucket = aws_s3_bucket.terrraform-backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.terrraform-backend.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_lock_table" {
  name         = "terraform-state-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  # The name of the primary key
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    bucket = "facial-recognition-terraform-backend"
    key    = "terraform.tfstate"
    region = "ap-southeast-2"

    dynamodb_table = "terraform-state-lock-table"
    encrypt        = true
  }
}