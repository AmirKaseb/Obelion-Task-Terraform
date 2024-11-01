variable "frontend_instance_id" {
  description = "The ID of the frontend EC2 instance"
  type        = string
}

variable "backend_instance_id" {
  description = "The ID of the backend EC2 instance"
  type        = string
}

variable "sns_topic_arn" {
  description = "The ARN of the SNS topic for alarm notifications"
  type        = string
}
