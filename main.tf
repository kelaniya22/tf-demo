# Specify the AWS provider
provider "aws" {
  region = var.AWS_REGION  # Using a variable for the region
}

# Define a variable for AWS region
variable "AWS_REGION" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-west-2"  # Default region (can be overridden through environment variables)
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

# Create a subnet in the VPC
resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"  # Use a valid AZ

  tags = {
    Name = "main-subnet"
  }
}

# Create a security group allowing SSH traffic
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-04dd23e62ed049936"  # Example AMI ID (replace with the appropriate AMI for your region)
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.subnet.id
  security_groups        = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true
  tags = {
    Name = "Example-Instance"
  }
}
