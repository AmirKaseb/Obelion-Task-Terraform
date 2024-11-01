# CloudWatch Alarm for Frontend Instance

resource "aws_cloudwatch_metric_alarm" "frontend_cpu_alarm" {
  alarm_name          = "Frontend-High-CPU-Usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "50"  # 50% CPU usage threshold
  alarm_description   = "This alarm triggers if the CPU utilization exceeds 50% for the frontend instance."

  dimensions = {
    InstanceId = var.frontend_instance_id
  }

  alarm_actions = [var.sns_topic_arn]
}

# CloudWatch Alarm for Backend Instance

resource "aws_cloudwatch_metric_alarm" "backend_cpu_alarm" {
  alarm_name          = "Backend-High-CPU-Usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "50"  # 50% CPU usage threshold
  alarm_description   = "This alarm triggers if the CPU utilization exceeds 50% for the backend instance."

  dimensions = {
    InstanceId = var.backend_instance_id
  }

  alarm_actions = [var.sns_topic_arn]
}
