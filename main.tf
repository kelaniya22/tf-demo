provider "aws" {
  region = "us-west-2"  # Specify the AWS region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"  # Use a valid AZ

  tags = {
    Name = "main-subnet"
  }
}

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

resource "aws_instance" "example" {
  ami           = "ami-04dd23e62ed049936"  # Example AMI ID (update with your region's AMI ID)
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.subnet.id
  security_groups        = [aws_security_group.allow_ssh.id]  # Wrap the security group ID in square brackets
  #key_name               = "mykey"  # Replace with your SSH key name
  associate_public_ip_address = true
  tags = {
    Name = "Example-Instance"
  }
}
