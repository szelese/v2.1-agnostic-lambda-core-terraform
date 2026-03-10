# Automatically update LAMBDA_URL in GitHub Secrets
resource "github_actions_secret" "lambda_url" {
  repository       = "v2.1-agnostic-lambda-core-terraform"
  secret_name      = "LAMBDA_URL"
  plaintext_value  = aws_lambda_function_url.api_url.function_url
}

# Automatically update SNS_TOPIC_ARN in GitHub Secrets
resource "github_actions_secret" "sns_topic_arn" {
  repository       = "v2.1-agnostic-lambda-core-terraform"
  secret_name      = "SNS_TOPIC_ARN"
  plaintext_value  = aws_sns_topic.pipeline_notifications.arn
}

/*
- Implemented GitHub provider to synchronize AWS outputs with GitHub Secrets.
- Automated updates for LAMBDA_URL and SNS_TOPIC_ARN to achieve zero-manual-step deployment.
- NOTE: Local Terraform execution now requires a Personal Access Token (PAT) 
  exported as GITHUB_TOKEN with 'repo' scope.
- Ensure to update the GitHub repository name in the github_actions_secret resources if you change it in variables.tf.
*/