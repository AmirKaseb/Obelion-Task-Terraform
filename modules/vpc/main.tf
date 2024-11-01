# Create a Virtual Private Cloud (VPC)
resource "aws_vpc" "Obelion_VPC" {
  cidr_block = var.vpc_cidr   # IP range for the VPC

  tags = {
    Name = "Obelion_VPC"
  }
}

# Create a public subnet in Availability Zone us-east-1a

resource "aws_subnet" "Obelion-Public-Subnet-1" {
  vpc_id                  = aws_vpc.Obelion_VPC.id  # IP range for the subnet
  cidr_block              = var.subnet_cidr_1
  availability_zone       = var.az_1
  map_public_ip_on_launch = true  # Enable public IP assignment for instances

  tags = {
    Name = "Obelion-Public-Subnet-1"
  }
}

# Create a public subnet in Availability Zone us-east-1b

resource "aws_subnet" "Obelion-Public-Subnet-2" {
  vpc_id                  = aws_vpc.Obelion_VPC.id
  cidr_block              = var.subnet_cidr_2   # IP range for the new subnet
  availability_zone       = var.az_2
  map_public_ip_on_launch = true  # Enable public IP assignment for instances

  tags = {
    Name = "Obelion-Public-Subnet-2"
  }
}

# Create an Internet Gateway (for internet access for frontend and backend instances)

resource "aws_internet_gateway" "Obelion_internet_gateway" {
  vpc_id = aws_vpc.Obelion_VPC.id

  tags = {
    Name = "Obelion_internet_gateway"
  }
}

# Create a Route Table to route traffic to the Internet Gateway

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

# Associate the Route Table with both Public Subnets

resource "aws_route_table_association" "Obelion_subnet_route_association_1" {
  subnet_id      = aws_subnet.Obelion-Public-Subnet-1.id
  route_table_id = aws_route_table.Obelion_route_table.id
}

resource "aws_route_table_association" "Obelion_subnet_route_association_2" {
  subnet_id      = aws_subnet.Obelion-Public-Subnet-2.id
  route_table_id = aws_route_table.Obelion_route_table.id
}
