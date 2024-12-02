terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.76.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

resource "aws_vpc" "myvpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name : "Terraform-vpc"
  }
}

resource "aws_subnet" "mysubnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name : "Mysubnet"
  }
}

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "my-route-table" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route" "myroutes" {
  route_table_id         = aws_route_table.my-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my-igw.id
}

resource "aws_route_table_association" "myrt_association" {
  route_table_id = aws_route_table.my-route-table.id
  subnet_id      = aws_subnet.mysubnet.id
}

resource "aws_security_group" "my-sg" {
  name        = "Allow_All"
  vpc_id      = aws_vpc.myvpc.id
  description = "Allow_All_traffic"
  ingress {
    description = "Allow_All"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow_All"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "myec2" {
  ami                         = "ami-0166fe664262f664c"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.mysubnet.id
  key_name                    = "AWSHYD"
  vpc_security_group_ids      = [aws_security_group.my-sg.id]
  associate_public_ip_address = true
  user_data                   = <<EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install httpd -y
  sudo systemctl start httpd
  sudo systemctl enable httpd
  echo "<h1> Welcome to AWS Terraform!!!. This Ec2 Instance is created using Terraform </h1>" >/var/www/html/index.html
  EOF
  tags = {
    Name = "Apache WebServer"
  }
}