# Define the provider (AWS)
provider "aws" {
  region = "us-west-2"  # Hardcoded AWS region (e.g., us-west-2)
}

# Create the main VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"  # CIDR block for the VPC

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

# Create a subnet within the VPC
resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"  # CIDR block for the subnet
  availability_zone       = "us-west-2a"    # Availability zone
  map_public_ip_on_launch = true  # Assign public IP to instances launched in this subnet

  tags = {
    Name = "main-subnet"
  }
}
