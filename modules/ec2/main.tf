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

# attach permission to read from s3 to ec2
resource "aws_iam_role" "facial_recognition_ec2_role" {
  name = "facial_recognition_ec2_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "facial_recognition_ec2_policy" {
  name = "facial_recognition_ec2_policy"
  description = "Allow EC2 to read from S3"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:*"
        ],
        Resource = [
          var.image_bucket_arn,
          "${var.image_bucket_arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "facial_recognition_ec2_policy_attachment" {
  role       = aws_iam_role.facial_recognition_ec2_role.name
  policy_arn = aws_iam_policy.facial_recognition_ec2_policy.arn
}

resource "aws_iam_policy" "facial_recognition_ec2_ecr_policy" {
  name = "facial_recognition_ec2_policy_ecr"
  description = "Allow EC2 to read from ECR"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "facial_recognition_ec2_ecr_policy_attachment" {
  role       = aws_iam_role.facial_recognition_ec2_role.name
  policy_arn = aws_iam_policy.facial_recognition_ec2_ecr_policy.arn
}

resource "aws_iam_policy" "facial_recognition_ec2_ssm_policy" {
  name = "facial_recognition_ec2_policy_ssm"
  description = "Allow EC2 to read from SSM"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameters",
          "ssm:GetParameter",
          "ssm:GetParametersByPath"
        ],
        Resource = ["${var.ssm_account_id_arn}", "${var.ssm_region_arn}", "${var.opensearch_domain_endpoint_arn}", "${var.opensearch_master_user_name_arn}", "${var.opensearch_master_user_password_arn}"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "facial_recognition_ec2_ssm_policy_attachment" {
  role       = aws_iam_role.facial_recognition_ec2_role.name
  policy_arn = aws_iam_policy.facial_recognition_ec2_ssm_policy.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.facial_recognition_ec2_role.name
}

resource "aws_instance" "facial_recognition_ec2" {
  ami           = var.ami_id
  availability_zone = var.aws_availability_zone
  instance_type = var.instance_type
  key_name      = aws_key_pair.rsa-4096-ec2.key_name
  security_groups = [aws_security_group.facial_recognition_ec2_sg.name]
  root_block_device {
    volume_size = 20
  }
  user_data = filebase64("${path.module}/initialconfigure_docker.sh")
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  tags = {
    Name = var.ec2_instance_name
  }
  depends_on = [ var.ec2_instance_depends_on ]
}

