output "image_s3_bucket_arn" {
  value = aws_s3_bucket.facial_recognition_s3_bucket.arn
  description = "The ARN of the S3 image bucket " 
}