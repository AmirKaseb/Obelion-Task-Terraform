# Created by: Amir Kasseb
# Date: 17/10/2024
# Purpose: Task for Obelion Internship
# -------------------------------------------------------------------
# Terraform script for deploying a cloud infrastructure on AWS,
# including a Virtual Private Cloud (VPC), EC2 instances, and an RDS
# (Relational Database Service) MySQL instance.
# -------------------------------------------------------------------
# Resources created:
# - A VPC with two public subnets for hosting application services
# - Two EC2 instances: one for the frontend and another for the backend
# - An RDS MySQL instance, with sensitive credentials securely stored
#   in AWS Secrets Manager
# - Security groups that allow the backend to access the RDS instance
#   on the specified port.
# -------------------------------------------------------------------
# Notes:
# 1. EC2 Instances: Running Ubuntu 22.04 LTS; instance type is t2.micro,
#    which is eligible for the AWS Free Tier.
# 2. RDS Instance: Utilizes MySQL version 8.0; credentials are fetched
#    dynamically from AWS Secrets Manager for enhanced security.
# 3. Security Groups: Configured to permit backend access to MySQL
#    on port 3306 only, ensuring minimal exposure to potential threats.
# -------------------------------------------------------------------

## VPC Module: Creates the Virtual Private Cloud
module "vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = var.vpc_cidr           # CIDR block for the VPC
  subnet_cidr_1 = var.subnet_cidr_1     # CIDR for the first public subnet
  subnet_cidr_2 = var.subnet_cidr_2     # CIDR for the second public subnet
  az_1         = var.az_1               # Availability Zone 1
  az_2         = var.az_2               # Availability Zone 2
}

## Security Groups Module: Configures security groups for the instances
module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id             # Passes the VPC ID to the security group module
}

## EC2 Module: Launches EC2 instances for frontend and backend services
module "ec2" {
  source         = "./modules/ec2"
  vpc_id         = module.vpc.vpc_id      # VPC ID for network configuration
  subnet_id      = module.vpc.subnet_id_1 # Subnet ID for deploying the EC2 instances
  ami_id         = var.ami_id             # Amazon Machine Image ID for the EC2 instances
  instance_type  = var.instance_type      # EC2 instance type (e.g., t2.micro)
  key_name       = var.key_name           # SSH key pair name for accessing the instances
  frontend_sg_id = module.security_groups.frontend_sg_id # Security group for frontend
  backend_sg_id  = module.security_groups.backend_sg_id  # Security group for backend
}

## RDS Module: Sets up the RDS MySQL database instance
module "rds" {
  source              = "./modules/rds"
  vpc_id              = module.vpc.vpc_id             # VPC ID for RDS deployment
  subnet_ids          = [module.vpc.subnet_id_1, module.vpc.subnet_id_2] # Subnets for RDS
  backend_subnet_cidr = var.subnet_cidr_1             # CIDR for backend subnet
  secret_name         = var.rds_secret_name            # Name of the Secrets Manager entry for credentials
}

## SNS Module: Configures Simple Notification Service for alerts
module "sns" {
  source         = "./modules/sns"
  email_endpoint = var.alarm_email                   # Email address for alarm notifications
}

## CloudWatch Module: Sets up CloudWatch monitoring and alarms
module "cloudwatch" {
  source               = "./modules/cloudwatch"
  frontend_instance_id = module.ec2.frontend_instance_id # Frontend EC2 instance ID for monitoring
  backend_instance_id  = module.ec2.backend_instance_id  # Backend EC2 instance ID for monitoring
  sns_topic_arn        = module.sns.sns_topic_arn        # SNS topic ARN for alerting
}
