output "sns_topic_arn" {
  value = aws_sns_topic.cpu_alarm_sns.arn
}
