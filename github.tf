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

# AWS Region automatically set as GitHub Actions variable
resource "github_actions_variable" "aws_region" {
  repository    = var.github_repo
  variable_name = "AWS_REGION"
  value         = var.aws_region
}

# AWS Account ID automatically set as GitHub Actions variable
resource "github_actions_variable" "aws_account_id" {
  repository    = var.github_repo
  variable_name = "AWS_ACCOUNT_ID"
  value         = var.aws_account_id
}

# ECR Repo name automatically set as GitHub Actions variable
resource "github_actions_variable" "ecr_repository_name" {
  repository    = var.github_repo
  variable_name = "ECR_REPOSITORY_NAME"
  value         = var.ecr_repository_name
}

# Lambda function name automatically set as GitHub Actions variable
resource "github_actions_variable" "lambda_function_name" {
  repository    = var.github_repo
  variable_name = "LAMBDA_FUNCTION_NAME"
  value         = var.lambda_function_name
}

# GitHub owner automatically set as GitHub Actions variable
resource "github_actions_variable" "repo_owner" {
  repository    = var.github_repo
  variable_name = "REPO_OWNER"
  value         = var.github_owner
}
