variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr_1" {
  default = "10.0.1.0/24"
}

variable "subnet_cidr_2" {
  default = "10.0.2.0/24"
}

variable "az_1" {
  default = "us-east-1a"
}

variable "az_2" {
  default = "us-east-1b"
}

variable "ami_id" {
  default = "ami-005fc0f236362e99f"  
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "Obelion_Task_KeyPair"
}

variable "rds_secret_name" {
  default = "RDS-Instance-SecretKey-v1"
}

variable "alarm_email" {
  default = "amir.m.kasseb@gmail.com"
}
