provider "aws" {
  region = "ap-south-1" # Mumbai region
}

# Security group to allow SSH access
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow from anywhere (for testing)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch 3 EC2 instances using the given AMI ID and key pair
resource "aws_instance" "amazon_linux_ec2" {
  count         = 3
  ami           = "ami-002f6e91abff6eb96" # Custom Amazon Linux 2 AMI ID
  instance_type = "t2.micro"
  key_name      = "ALL" # ✅ Your key pair name (just the name, not .pem)
  security_groups = [aws_security_group.ec2_sg.name]

  tags = {
    Name = "AmazonLinux2-EC2-${count.index + 1}"
  }
}
