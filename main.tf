# Created by : Amir Kasseb , Date : 17/10/2024 , Purpose : Task for Obelion Internship
# -------------------------------------------------------------------
# Terraform script for deploying infrastructure on AWS (VPC, EC2, RDS)
# -------------------------------------------------------------------
# Resources created:
# - A VPC with two public subnets
# - Two EC2 instances (frontend and backend)
# - RDS MySQL instance with credentials stored in Secrets Manager
# - Security group allowing backend to access RDS
# -------------------------------------------------------------------
# Notes:
# 1. EC2 instances: Ubuntu 22.04 LTS (t2.micro, Free Tier eligible)
# 2. RDS instance: MySQL 8.0 with credentials fetched from AWS Secrets Manager
# 3. Security groups: Backend can access MySQL on port 3306 only,
# -------------------------------------------------------------------

# AWS Provider Configuration
provider "aws" {
  region = "us-east-1"  # Specify the region where resources will be deployed
}

# Create a Virtual Private Cloud (VPC)
resource "aws_vpc" "Obelion_VPC" {
  cidr_block = "10.0.0.0/16"  # IP range for the VPC

  tags = {
    Name = "Obelion_VPC"
  }
}

# Create a public subnet in Availability Zone us-east-1a
resource "aws_subnet" "Obelion-Public-Subnet-1" {
  vpc_id                  = aws_vpc.Obelion_VPC.id
  cidr_block              = "10.0.1.0/24"  # IP range for the subnet
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true  # Enable public IP assignment for instances

  tags = {
    Name = "Obelion-Public-Subnet-1"
  }
}

# Create a public subnet in Availability Zone us-east-1b
resource "aws_subnet" "Obelion-Public-Subnet-2" {
  vpc_id                  = aws_vpc.Obelion_VPC.id
  cidr_block              = "10.0.2.0/24"  # IP range for the new subnet
  availability_zone       = "us-east-1b"
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
    cidr_block = "0.0.0.0/0"  # Route all traffic to the internet
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

# Security Group for Frontend (Allow HTTP, HTTPS, and SSH)
resource "aws_security_group" "Obelion_frontend_sg" {
  vpc_id = aws_vpc.Obelion_VPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP access from anywhere
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTPS access from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Obelion-frontend-sg"
  }
}

# Security Group for Backend (Allow MySQL and SSH)
resource "aws_security_group" "Obelion_backend_sg" {
  vpc_id = aws_vpc.Obelion_VPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from anywhere
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow Accesing the default port for Laravel's development server
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Obelion-backend-sg"
  }
}


# Backend instance
resource "aws_instance" "Obelion_backend_instance" {
  ami                          = "ami-005fc0f236362e99f"
  instance_type                = "t2.micro"
  key_name                     = "Obelion_Task_KeyPair"
  subnet_id                    = aws_subnet.Obelion-Public-Subnet-1.id
  associate_public_ip_address   = true
  vpc_security_group_ids        = [aws_security_group.Obelion_backend_sg.id]  # Correct the reference

  # Define the user data to install Docker
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install docker.io -y
              sudo systemctl start docker
              sudo systemctl enable docker
              docker --version
              sudo usermod -a -G docker $(whoami)
              sudo chmod 666 /var/run/docker.sock
              newgrp docker
            EOF

  tags = {
    Name = "Obelion_backend_instance"
  }
}

# Frontend instance
resource "aws_instance" "Obelion_frontend_instance" {
  ami                          = "ami-005fc0f236362e99f"
  instance_type                = "t2.micro"
  key_name                     = "Obelion_Task_KeyPair"
  subnet_id                    = aws_subnet.Obelion-Public-Subnet-1.id
  vpc_security_group_ids        = [aws_security_group.Obelion_frontend_sg.id]  # Correct the reference
  associate_public_ip_address   = true

  # Define the user data to install Docker
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install docker.io -y
              sudo systemctl start docker
              sudo systemctl enable docker
              docker --version
              sudo usermod -a -G docker $(whoami)
              sudo chmod 666 /var/run/docker.sock
              newgrp docker
            EOF


  tags = {
    Name = "Obelion_frontend_instance"
  }
}

# **Secrets Manager: Retrieve RDS Instance credentials**
data "aws_secretsmanager_secret" "rds_secret" {
  name = "RDS-Instance-SecretKey-v1"  # Correct attribute name
}

data "aws_secretsmanager_secret_version" "rds_secret_value" {
  secret_id = data.aws_secretsmanager_secret.rds_secret.id  # Use the secret's ID to get the version
}

# **MySQL RDS (Community Edition, no public access)**
resource "aws_db_instance" "mysql_rds" {
  allocated_storage    = 8  # 8 GB storage
  storage_type         = "gp2"  # General Purpose SSD
  engine               = "mysql"
  engine_version       = "8.0"  # MySQL 8.0
  instance_class       = "db.t3.micro"  # Lowest instance size
  db_name              = "mydatabase"
  username             = jsondecode(data.aws_secretsmanager_secret_version.rds_secret_value.secret_string)["username"] # Get username from secrets manager
  password             = jsondecode(data.aws_secretsmanager_secret_version.rds_secret_value.secret_string)["password"] # Get Password from secrets manager
  publicly_accessible  = false  # No internet access for MySQL
  vpc_security_group_ids = [aws_security_group.Obelio_mysql_sg.id]
  db_subnet_group_name  = aws_db_subnet_group.Obelion-Public-Subnet-Group.name  # Updated reference
  multi_az             = true  # Enable Multi-AZ for availability
  tags = {
    Name = "Obelion_MySqL_Database"
  }
}

# Create a security group for the MySQL RDS instance (only allowing access from the backend)
resource "aws_security_group" "Obelio_mysql_sg" {
  vpc_id = aws_vpc.Obelion_VPC.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]  # Allow access from the backend public instance
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "obelion-mysql-sg"
  }
}

# Create a DB subnet group for the RDS instance (covering both public subnets)
resource "aws_db_subnet_group" "Obelion-Public-Subnet-Group" {
  subnet_ids = [
    aws_subnet.Obelion-Public-Subnet-1.id,
    aws_subnet.Obelion-Public-Subnet-2.id
  ]

  tags = {
    Name = "Obelion-Public-Subnet-Group"
  }
}

# Create an SNS Topic for Email Notifications

resource "aws_sns_topic" "cpu_alarm_sns" {
  name = "cpu_alarm_sns_topic"
}

resource "aws_sns_topic_subscription" "cpu_alarm_subscription" {
  topic_arn = aws_sns_topic.cpu_alarm_sns.arn
  protocol  = "email"
  endpoint  = "amir.m.kasseb@gmail.com"  # Your email address
}


# CloudWatch Alarm for Frontend Instance
resource "aws_cloudwatch_metric_alarm" "frontend_cpu_alarm" {
  alarm_name          = "Frontend-High-CPU-Usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "50"  # 50% CPU usage threshold
  alarm_description   = "This alarm triggers if the CPU utilization exceeds 50% for the frontend instance."

  dimensions = {
    InstanceId = aws_instance.Obelion_frontend_instance.id
  }

  alarm_actions = [aws_sns_topic.cpu_alarm_sns.arn]
}

# CloudWatch Alarm for Backend Instance
resource "aws_cloudwatch_metric_alarm" "backend_cpu_alarm" {
  alarm_name          = "Backend-High-CPU-Usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "50"  # 50% CPU usage threshold
  alarm_description   = "This alarm triggers if the CPU utilization exceeds 50% for the backend instance."

  dimensions = {
    InstanceId = aws_instance.Obelion_backend_instance.id
  }

  alarm_actions = [aws_sns_topic.cpu_alarm_sns.arn]
}



# Output public IPs of the frontend and backend instances
output "Obelion_frontend_instance_public_ip" {
  value = aws_instance.Obelion_frontend_instance.public_ip
}

output "Obelion_backend_instance_public_ip" {
  value = aws_instance.Obelion_backend_instance.public_ip
}

# Output the endpoint of the MySQL RDS instance
output "mysql_rds_endpoint" {
  value = aws_db_instance.mysql_rds.endpoint
}

