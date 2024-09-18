resource "aws_ebs_volume" "facial_recognition_ebs_volume" {
  availability_zone = var.aws_availability_zone
  size              = var.ebs_volume_size
  tags = {
    Name = "facial-recognition-ebs-volume"
  }
}
resource "aws_volume_attachment" "facial_recognition_ebs_volume_attachment" {
  device_name = var.ebs_device_name
  instance_id = var.ec2_instance_id
  volume_id   = aws_ebs_volume.facial_recognition_ebs_volume.id
}