# Output public IP of the frontend instance

output "Obelion_frontend_instance_public_ip" {
  value = module.ec2.frontend_instance_public_ip
}

# Output public IP of the backend instance

output "Obelion_backend_instance_public_ip" {
  value = module.ec2.backend_instance_public_ip
}

# Output the endpoint of the MySQL RDS instance

output "mysql_rds_endpoint" {
  value = module.rds.rds_endpoint
}
