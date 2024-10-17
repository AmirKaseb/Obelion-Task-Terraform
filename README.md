# Terraform AWS Infrastructure Deployment
### Created by: Amir Kasseb  
### Date: 17/10/2024  
### Purpose: Task for Obelion Internship

---

![AWS Task  Architecture ](Architceture.png)

## Overview

This repository contains a Terraform script to automate the deployment of infrastructure on AWS, including a Virtual Private Cloud (VPC), two EC2 instances (frontend and backend), an RDS MySQL database, and necessary security groups. The infrastructure is designed to support a basic web application with separate frontend and backend services.

## Resources Created

- **VPC**: A Virtual Private Cloud with two public subnets.
- **EC2 Instances**:
  - **Frontend**: Serves the user-facing application.
  - **Backend**: Hosts the backend logic.
- **RDS MySQL**: A managed MySQL instance, with credentials stored in AWS Secrets Manager.
- **Security Groups**: Control inbound and outbound traffic, including:
  - SSH, HTTP/HTTPS access for frontend
  - MySQL access restricted to the backend
  - CloudWatch alarms for monitoring high CPU usage on EC2 instances.
- **CloudWatch**: Monitoring alarms for CPU usage, with notifications sent via SNS.
- **AWS SNS**: Sends email notifications when CloudWatch alarms are triggered.

---

## Prerequisites

- **Terraform**: Installed on your local machine (v1.0+).
- **AWS Account**: Set up with credentials for programmatic access (e.g., via `aws configure`).
- **SSH Key**: You should have an existing AWS key pair (`Obelion_Task_KeyPair`) to access the EC2 instances.
- **Secrets Manager**: A secret stored in AWS Secrets Manager with the RDS credentials (`RDS-Instance-SecretKey-v1`).

---

## Infrastructure Components

### VPC and Networking
- **VPC**: A custom VPC (`10.0.0.0/16` CIDR block) is created to host the infrastructure.
- **Subnets**: Two public subnets are created in different availability zones (AZs):
  - `us-east-1a`: `10.0.1.0/24`
  - `us-east-1b`: `10.0.2.0/24`
- **Internet Gateway**: Allows public access to instances within the subnets.
- **Route Table**: Ensures that traffic from the subnets is routed to the Internet Gateway.

### EC2 Instances
- **Frontend**: Ubuntu 22.04 LTS (t2.micro), serves web traffic over HTTP/HTTPS. Docker is installed for containerized deployment.
- **Backend**: Ubuntu 22.04 LTS (t2.micro), accesses the MySQL database and processes requests. Docker is installed for backend service management.

### RDS MySQL Database
- **RDS Instance**: MySQL 8.0 with Multi-AZ deployment, private access only (no public IP).
- **Secrets Manager**: Retrieves database credentials (username and password) securely from AWS Secrets Manager.

### Security Groups
- **Frontend Security Group**: Allows inbound HTTP (80), HTTPS (443), and SSH (22) traffic.
- **Backend Security Group**: Allows SSH access and MySQL communication over port 3306 from the backend instance.
- **MySQL Security Group**: Restricts MySQL access to backend instances only.

---

## Monitoring and Alerts
- **CloudWatch Alarms**: Monitors CPU usage for both the frontend and backend instances.
  - Alarms trigger when CPU usage exceeds 50% for 1 minute.
  - **SNS**: Sends an email notification to `amir.m.kasseb@gmail.com` when alarms are triggered.

---
