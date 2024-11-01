variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnet_cidr_1" {
  description = "CIDR block for the first subnet"
  type        = string
}

variable "subnet_cidr_2" {
  description = "CIDR block for the second subnet"
  type        = string
}

variable "az_1" {
  description = "Availability Zone for the first subnet"
  type        = string
}

variable "az_2" {
  description = "Availability Zone for the second subnet"
  type        = string
}
