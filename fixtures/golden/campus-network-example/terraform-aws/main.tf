#
# cidrly Network Configuration
# Plan: Campus Network Example
# Provider: AWS
# Generated: <timestamp>
#

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  plan_name = "campus_network_example"
  base_cidr = "10.100.0.0/21"
  tags = {
    ManagedBy = "cidrly"
    PlanName  = "Campus Network Example"
  }
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = local.base_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.tags, {
    Name = "${local.plan_name}-vpc"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.tags, {
    Name = "${local.plan_name}-igw"
  })
}

# Subnet: Student WiFi (VLAN 30)
resource "aws_subnet" "student_wifi" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.100.0.0/23"
  availability_zone = "${var.aws_region}a"

  tags = merge(local.tags, {
    Name   = "student_wifi"
    VlanId = "30"
  })
}

# Subnet: Engineering Building (VLAN 10)
resource "aws_subnet" "engineering_building" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.100.2.0/24"
  availability_zone = "${var.aws_region}a"

  tags = merge(local.tags, {
    Name   = "engineering_building"
    VlanId = "10"
  })
}

# Subnet: Science Lab (VLAN 20)
resource "aws_subnet" "science_lab" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.100.3.0/24"
  availability_zone = "${var.aws_region}a"

  tags = merge(local.tags, {
    Name   = "science_lab"
    VlanId = "20"
  })
}

# Subnet: Guest WiFi (VLAN 50)
resource "aws_subnet" "guest_wifi" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.100.4.0/25"
  availability_zone = "${var.aws_region}a"

  tags = merge(local.tags, {
    Name   = "guest_wifi"
    VlanId = "50"
  })
}

# Subnet: Administration (VLAN 40)
resource "aws_subnet" "administration" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.100.4.128/26"
  availability_zone = "${var.aws_region}a"

  tags = merge(local.tags, {
    Name   = "administration"
    VlanId = "40"
  })
}

# Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(local.tags, {
    Name = "${local.plan_name}-rt"
  })
}

resource "aws_route_table_association" "student_wifi" {
  subnet_id      = aws_subnet.student_wifi.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "engineering_building" {
  subnet_id      = aws_subnet.engineering_building.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "science_lab" {
  subnet_id      = aws_subnet.science_lab.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "guest_wifi" {
  subnet_id      = aws_subnet.guest_wifi.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "administration" {
  subnet_id      = aws_subnet.administration.id
  route_table_id = aws_route_table.main.id
}

# Security Group
resource "aws_security_group" "main" {
  name        = "${local.plan_name}-sg"
  description = "Security group for ${local.plan_name}"
  vpc_id      = aws_vpc.main.id

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH from VPC
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.base_cidr]
  }

  # Allow HTTPS from VPC
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [local.base_cidr]
  }

  tags = merge(local.tags, {
    Name = "${local.plan_name}-sg"
  })
}
