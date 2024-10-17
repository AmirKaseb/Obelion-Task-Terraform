Terraform AWS Infrastructure Deployment
Overview

This Terraform script is designed to automate the deployment of infrastructure on AWS for an internship task at Obelion. It provisions the following resources:

    VPC with two public subnets.
    Two EC2 Instances for frontend and backend services.
    RDS MySQL Instance with credentials securely stored in AWS Secrets Manager.
    Security Groups to manage access between resources.
    SNS Notifications to send alerts for high CPU usage.

Key Resources

    VPC: Virtual Private Cloud with two public subnets.
    EC2 Instances:
        Frontend: Running on Ubuntu, Docker installed.
        Backend: Running on Ubuntu, Docker installed.
    RDS: MySQL database in a private subnet, with credentials stored in AWS Secrets Manager.
    Security Groups:
        Frontend: Allows HTTP, HTTPS, and SSH access.
        Backend: Allows SSH and MySQL access from the frontend.
    CloudWatch Alarms: CPU usage alarms for both frontend and backend, with email notifications through SNS.

Components

    VPC and Subnets
        A Virtual Private Cloud with two public subnets.
        An Internet Gateway for internet access.
        A Route Table to route traffic to the Internet Gateway.

    EC2 Instances
        Frontend and Backend instances are provisioned using t2.micro (Free Tier eligible).
        Docker is installed using user data scripts during instance initialization.

    RDS MySQL Instance
        MySQL 8.0 RDS instance with credentials pulled from Secrets Manager.
        Security group allows access to MySQL only from the backend instance.

    Security Groups
        For the frontend and backend to control access to the necessary ports (SSH, HTTP, MySQL).

    SNS Topic for Notifications
        Sends email alerts if CPU usage on either frontend or backend EC2 instances exceeds 50%.

    CloudWatch Alarms
        Monitors CPU utilization and triggers the SNS notification when it exceeds the defined threshold (50%).

Usage

    Set Up AWS CLI: Ensure AWS credentials are configured with the required permissions for EC2, VPC, RDS, CloudWatch, and SNS.

    Run Terraform:
        terraform init to initialize the working directory.
        terraform apply to deploy the resources.

    Verify Deployment:
        Check the AWS Management Console to confirm the creation of VPC, EC2 instances, RDS instance, security groups, and SNS topic.

    Monitor Alerts:
        If the CPU usage exceeds 50%, you will receive an email notification from the SNS topic.

Email Notifications

    Email notifications are sent to amir.m.kasseb@gmail.com when CPU usage on the frontend or backend instance exceeds 50%.
    Modify the email address in the SNS subscription resource if you need to send alerts to a different address.

Customizations

    Region: The script is set to deploy in the us-east-1 region. Modify the provider configuration if you need to use a different region.
    Instance Types: The instances are using the t2.micro type. You can adjust the instance types in the aws_instance resources based on your requirements.
