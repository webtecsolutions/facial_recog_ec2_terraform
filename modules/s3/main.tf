resource "aws_s3_bucket" "facial_recognition_s3_bucket" {
  bucket = var.image_bucket_name
  force_destroy = true
}