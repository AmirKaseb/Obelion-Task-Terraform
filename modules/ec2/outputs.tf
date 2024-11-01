output "frontend_instance_public_ip" {
  value = aws_instance.Obelion_frontend_instance.public_ip
}

output "backend_instance_public_ip" {
  value = aws_instance.Obelion_backend_instance.public_ip
}
output "frontend_instance_id" {
  value = aws_instance.Obelion_frontend_instance.id
}

output "backend_instance_id" {
  value = aws_instance.Obelion_backend_instance.id
}