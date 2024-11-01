output "Obelion_frontend_instance_public_ip" {
  value = module.ec2.frontend_instance_public_ip
}

output "Obelion_backend_instance_public_ip" {
  value = module.ec2.backend_instance_public_ip
}

output "mysql_rds_endpoint" {
  value = module.rds.rds_endpoint
}
