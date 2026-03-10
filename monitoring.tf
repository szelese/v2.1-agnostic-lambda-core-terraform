resource "aws_sns_topic" "pipeline_notifications" {
  name = "v2-1-pipeline-notifications"
}

resource "aws_sns_topic_subscription" "email_target" {
  topic_arn = aws_sns_topic.pipeline_notifications.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

resource "aws_cloudwatch_metric_alarm" "lambda_error" {
  alarm_name          = "v2-1-Lambda-Error-Alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 1

  dimensions = {
    FunctionName = aws_lambda_function.api_core.function_name
  }

  alarm_actions = [aws_sns_topic.pipeline_notifications.arn]
}