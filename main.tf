# Create a VPC
resource "aws_vpc" "main" {
  cidr_block           = "3.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main_vpc"
  }
}

# Create a subnet
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "3.0.1.0/24"
  availability_zone = "us-east-1a" # Change to your preferred availability zone

  tags = {
    Name = "main_subnet"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main_internet_gateway"
  }
}

# Create a route table and associate it with the subnet
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "main_route_table"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# Create a security group
resource "aws_security_group" "main" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "main_security_group"
  }
}

# Create an EC2 instance
resource "aws_instance" "main" {
  ami           = "ami-01fccab91b456acc2" # Replace with a valid AMI ID for your region
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id
  key_name      = "ec2-keypair" # Replace with your key pair name

  tags = {
    Name = "t2_micro_instance"
  }

  vpc_security_group_ids = [aws_security_group.main.id]
}

# Allocate an Elastic IP
resource "aws_eip" "main" {
  instance = aws_instance.main.id

  tags = {
    Name = "main_elastic_ip"
  }
}
