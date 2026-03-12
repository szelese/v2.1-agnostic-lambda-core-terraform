# Lambda Execution Role
resource "aws_iam_role" "lambda_exec" {
  name = "v2.1-lambda-ex-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# === CUSTOM ECR POLICY – only to own repo (least privilege) ===
resource "aws_iam_policy" "gha_ecr_access" {
  name        = "v2-1-gha-ecr-limited"
  description = "Limited access only to our ECR repository"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload"
      ]
      Resource = [
        aws_ecr_repository.lambda_core.arn,
        "${aws_ecr_repository.lambda_core.arn}/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "gha_ecr_access_attach" {
  role       = aws_iam_role.gha_deploy.name
  policy_arn = aws_iam_policy.gha_ecr_access.arn
}

# GitHub Actions OIDC Provider
data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

# GitHub Actions Deploy Role
resource "aws_iam_role" "gha_deploy" {
  name = var.gha_deploy_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = data.aws_iam_openid_connect_provider.github.arn
      }
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:${var.github_owner}/${var.github_repo}:*"
        }
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}

# Policy to allow GitHub Actions to update the Lambda function
resource "aws_iam_role_policy" "gha_lambda_update" {
  name = "v2.1-gha-lambda-update-policy"
  role = aws_iam_role.gha_deploy.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration",
          "lambda:GetFunction",
          "lambda:GetFunctionConfiguration"
        ]
        # Restrict to the specific Lambda function for security
        Resource = aws_lambda_function.api_core.arn
      }
    ]
  })
}

# Allow GitHub Actions to publish notifications to the SNS topic
resource "aws_iam_role_policy" "gha_sns_publish" {
  name = "v2.1-gha-sns-publish-policy"
  role = aws_iam_role.gha_deploy.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sns:Publish"
        Resource = aws_sns_topic.pipeline_notifications.arn
      }
    ]
  })
}