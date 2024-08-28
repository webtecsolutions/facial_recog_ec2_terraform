# RSA key of size 4096 bits
# Assymetric encryption
# Creates a PEM (and OpenSSH) formatted private key.
resource "tls_private_key" "rsa-4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


# Supply the public key to the AWS key pair resource
resource "aws_key_pair" "rsa-4096-ec2" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa-4096.public_key_openssh
}

resource "local_file" "rsa-4096-private" {
  content  = tls_private_key.rsa-4096.private_key_pem
  filename = var.file_path
}

resource "aws_security_group" "facial_recognition_ec2_sg" {
  name        = "facial-recognition-ec2-sg"
  description = "Allow inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP inbound traffic"
  }
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP inbound traffic"
  }
  ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow SSH inbound traffic"
  }

  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow all outbound traffic"
  }


}

resource "aws_instance" "facial_recognition_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.rsa-4096-ec2.key_name
  security_groups = [aws_security_group.facial_recognition_ec2_sg.name]
  user_data = filebase64("${path.module}/initialconfigure.sh")
  tags = {
    Name = var.ec2_instance_name
  }

}

