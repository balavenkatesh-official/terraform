
terraform {
  # required_version = "0.12.29"
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

provider "random" {
  #version = "=4.4.0"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "application-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["${var.region}a"]
  public_subnets = ["10.0.101.0/24"]

  tags = {
    createdBy = "<%=username%>"
  }
}

resource "random_string" "random" {
  length           = 3
  special          = true
  override_special = "/@£$"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.instance_ssh_public_key
}

resource "aws_instance" "app_vm" {
  # Amazon Linux 2 AMI (HVM), SSD Volume Type
  ami                         = var.ami
  instance_type               = "t2.medium"
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.vm_sg.id]
  key_name                    = aws_key_pair.deployer.key_name
  associate_public_ip_address = false

  tags = {
    Name      = "application-vm"
    createdBy = "listentolearn"
  }
}

resource "aws_eip" "elastic_ip" {
  instance = aws_instance.app_vm.id
  vpc      = true
}

resource "aws_security_group" "vm_sg" {
  name        = "vm-security-group"
  description = "Allow incoming connections."
  
  tags = {
    Name      = "application-security_group"
    createdBy = "bala"
  }

  vpc_id = module.vpc.vpc_id

  # allow 22,80,443 ports on inbound rule

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

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


