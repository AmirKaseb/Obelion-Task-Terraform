resource "aws_vpc" "Obelion_VPC" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "Obelion_VPC"
  }
}

resource "aws_subnet" "Obelion-Public-Subnet-1" {
  vpc_id                  = aws_vpc.Obelion_VPC.id
  cidr_block              = var.subnet_cidr_1
  availability_zone       = var.az_1
  map_public_ip_on_launch = true

  tags = {
    Name = "Obelion-Public-Subnet-1"
  }
}

resource "aws_subnet" "Obelion-Public-Subnet-2" {
  vpc_id                  = aws_vpc.Obelion_VPC.id
  cidr_block              = var.subnet_cidr_2
  availability_zone       = var.az_2
  map_public_ip_on_launch = true

  tags = {
    Name = "Obelion-Public-Subnet-2"
  }
}

resource "aws_internet_gateway" "Obelion_internet_gateway" {
  vpc_id = aws_vpc.Obelion_VPC.id

  tags = {
    Name = "Obelion_internet_gateway"
  }
}

resource "aws_route_table" "Obelion_route_table" {
  vpc_id = aws_vpc.Obelion_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Obelion_internet_gateway.id
  }

  tags = {
    Name = "Obelion_route_table"
  }
}

resource "aws_route_table_association" "Obelion_subnet_route_association_1" {
  subnet_id      = aws_subnet.Obelion-Public-Subnet-1.id
  route_table_id = aws_route_table.Obelion_route_table.id
}

resource "aws_route_table_association" "Obelion_subnet_route_association_2" {
  subnet_id      = aws_subnet.Obelion-Public-Subnet-2.id
  route_table_id = aws_route_table.Obelion_route_table.id
}
