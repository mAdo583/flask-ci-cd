provider "aws" {
  region = "us-east-1"  # Update to your desired AWS region
}

# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "EKS-Cluster-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

# IAM Role for EC2 Instance Profile (to interact with EKS if needed)
resource "aws_iam_role" "eks_instance_role" {
  name = "EKS-Instance-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Instance Profile for EC2
resource "aws_iam_instance_profile" "eks_instance_profile" {
  name = "eks_instance_profile"
  role = aws_iam_role.eks_instance_role.name
}

# EC2 Instance
resource "aws_instance" "my_ec2" {
  ami           = "ami-04b4f1a9cf54c11d0"  # Replace with your AMI ID
  instance_type = "t3.micro"

  key_name = "terraform"  # Replace with your SSH key pair name
  vpc_security_group_ids = ["sg-0231cd01a0b1836ec"]  # Replace with your security group ID

  iam_instance_profile = aws_iam_instance_profile.eks_instance_profile.name

  tags = {
    Name = "MyEC2Instance"
  }

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 8
    volume_type = "gp2"
  }
}

# EKS Cluster
resource "aws_eks_cluster" "flask_eks" {
  name     = "flask-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      "subnet-03bf7a623762ae307",  # Public Subnet 1
      "subnet-04acd3445f59046ff"   # Public Subnet 2
    ]
  }

  depends_on = [aws_iam_role.eks_cluster_role]
}

# Output the EC2 Instance Public IP
output "instance_public_ip" {
  value = aws_instance.my_ec2.public_ip
}

