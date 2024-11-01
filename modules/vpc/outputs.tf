output "vpc_id" {
  value = aws_vpc.Obelion_VPC.id
}

output "subnet_id_1" {
  value = aws_subnet.Obelion-Public-Subnet-1.id
}

output "subnet_id_2" {
  value = aws_subnet.Obelion-Public-Subnet-2.id
}