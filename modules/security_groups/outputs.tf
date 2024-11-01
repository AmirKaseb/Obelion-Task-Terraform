output "frontend_sg_id" {
  description = "The ID of the frontend security group"
  value       = aws_security_group.Obelion_frontend_sg.id
}

output "backend_sg_id" {
  description = "The ID of the backend security group"
  value       = aws_security_group.Obelion_backend_sg.id
}
