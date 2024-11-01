resource "aws_sns_topic" "cpu_alarm_sns" {
  name = "cpu_alarm_sns_topic"
}

resource "aws_sns_topic_subscription" "cpu_alarm_subscription" {
  topic_arn = aws_sns_topic.cpu_alarm_sns.arn
  protocol  = "email"
  endpoint  = var.email_endpoint
}
