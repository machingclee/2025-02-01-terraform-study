resource "random_integer" "random" {
  min = 1
  max = 100
}

data "aws_availability_zones" "available" {
  state = "available"
}


resource "aws_vpc" "james_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "james_vpc-${random_integer.random.id}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "james_public_subnet_association" {
  count          = length(var.public_cidrs)
  subnet_id      = aws_subnet.james_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.james_public_route_table.id
}


resource "aws_subnet" "james_public_subnet" {
  count                   = length(var.public_cidrs)
  vpc_id                  = aws_vpc.james_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "james_public_subnet_${count.index + 1}"
  }
}


resource "aws_subnet" "james_private_subnet" {
  count                   = length(var.private_cidrs)
  vpc_id                  = aws_vpc.james_vpc.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "james_private_subnet_${count.index + 1}"
  }
}

resource "aws_internet_gateway" "james_internet_gateway" {
  vpc_id = aws_vpc.james_vpc.id
  tags = {
    Name = "james_igw"
  }
}

resource "aws_route_table" "james_public_route_table" {
  vpc_id = aws_vpc.james_vpc.id
  tags = {
    Name = "james_public_route_table"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.james_internet_gateway.id
  }
}

# default VPC comes with an Internet Gateway and internet access pre-configured because 
# it's designed for immediate use and backward compatibility with EC2-Classic. 
# It's meant to help users get started quickly, while custom VPCs follow stricter security practices.

# for new VPC there is no internet gateway and therefore its default route table is a suitable candidate to be assigned 
# to private subnet, and we create additional one for public subnet with a record from igw to 0.0.0.0/0
resource "aws_default_route_table" "james_private_route_table" {
  default_route_table_id = aws_vpc.james_vpc.default_route_table_id

  tags = {
    Name = "james_private_route_table"
  }
}

resource "aws_security_group" "james_ssh_sg" {
  name        = "ssh_sg"
  description = "Security Group for SSH Access"
  vpc_id      = aws_vpc.james_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_access_ip]
    description = "for SSH access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "james_http_sg" {
  name        = "james_http_sg"
  description = "Security Group for Http"
  vpc_id      = aws_vpc.james_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "port 80 for public access"
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "port 8000 for public access"
  }
}

resource "aws_security_group" "ec2_security_group" {
  name        = "james_ec2_sg"
  description = "Security Group for EC2"
  vpc_id      = aws_vpc.james_vpc.id
}


resource "aws_security_group" "james_private_rds" {
  name        = "james_private_rds"
  description = "Security Group for Private RDS"
  vpc_id      = aws_vpc.james_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "pgsql allows everything in the VPC to access"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_subnet_group" "james_rds_subnet_group" {
  count      = var.create_db_subnet_group == true ? 1 : 0
  name       = "james_rds_subnet_group"
  subnet_ids = aws_subnet.james_private_subnet.*.id
  tags = {
    Name = "james_rds_subnet_group"
  }
}
