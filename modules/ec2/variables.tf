variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet for EC2 instances"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
}

variable "key_name" {
  description = "Name of the key pair for EC2 instances"
  type        = string
}

variable "frontend_sg_id" {
  description = "The ID of the frontend security group"
  type        = string
}

variable "backend_sg_id" {
  description = "The ID of the backend security group"
  type        = string
}
