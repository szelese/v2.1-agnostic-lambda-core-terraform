output "ecr_repository_url" {
  value = aws_ecr_repository.lambda_core.repository_url
}

output "lambda_function_url" {
  value = aws_lambda_function_url.api_url.function_url
}

output "oidc_role_arn" {
  value = aws_iam_role.gha_deploy.arn
}