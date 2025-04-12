
# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"  # Change to your preferred region
}

# Create an EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-002f6e91abff6eb96"  # Amazon Linux 2 AMI (update based on region)
  instance_type = "t2.micro"               # Free tier eligible instance type
  
  # Optional: Add a key pair for SSH access
  key_name      = "allinonelock"           # Replace with your key pair name
  
  # Optional: Security group to allow SSH
  vpc_security_group_ids = [aws_security_group.example_sg.id]
  
  # Optional: Add tags
  tags = {
    Name = "purushotham-server1"
    Environment = "Test"
  }
  
  # Optional: User data to run at launch
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from Terraform EC2</h1>" > /var/www/html/index.html
              EOF
}

# Create a security group
resource "aws_security_group" "example_sg" {
  name        = "example-sg"
  description = "Allow SSH and HTTP"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Warning: This allows SSH from anywhere
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "example-sg"
  }
}

# Optional: Output the public IP
output "instance_public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP address of the EC2 instance"
}
