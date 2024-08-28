output "ec2_instance_public_ip" {
    value = aws_instance.facial_recognition_ec2.public_ip
    description = "The public IP address of the EC2 instance"
}