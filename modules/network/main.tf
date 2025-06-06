resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Environment = var.environment
    Name = "${var.environment}-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Environment = var.environment
    Name = "${var.environment}=public-subnet"
  }
}

resource "aws_subnet" "private" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_cidr
    availability_zone = var.availability_zone
    map_public_ip_on_launch = false

    tags = {
        Environment = var.environment
        Name = "${var.environment}-private-subnet"
    }
}