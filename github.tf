# Automatically update LAMBDA_URL in GitHub Secrets
resource "github_actions_secret" "lambda_url" {
  repository       = var.github_repo
  secret_name      = "LAMBDA_URL"
  plaintext_value  = aws_lambda_function_url.api_url.function_url
}

# Automatically update SNS_TOPIC_ARN in GitHub Secrets
resource "github_actions_secret" "sns_topic_arn" {
  repository       = var.github_repo
  secret_name      = "SNS_TOPIC_ARN"
  plaintext_value  = aws_sns_topic.pipeline_notifications.arn
}

