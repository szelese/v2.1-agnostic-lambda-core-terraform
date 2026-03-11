# Push initial dummy image to ECR to satisfy Lambda image requirement
resource "null_resource" "push_dummy_image" {
  triggers = {
    ecr_repository_url = aws_ecr_repository.lambda_core.repository_url
  }

  provisioner "local-exec" {
    command = <<EOF
      aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.lambda_core.registry_id}.dkr.ecr.${var.aws_region}.amazonaws.com
      docker pull public.ecr.aws/lambda/provided:al2023
      docker tag public.ecr.aws/lambda/provided:al2023 ${aws_ecr_repository.lambda_core.repository_url}:latest
      docker push ${aws_ecr_repository.lambda_core.repository_url}:latest
    EOF
  }
}

# Create Lambda function using the dummy image
resource "aws_lambda_function" "api_core" {
  depends_on    = [null_resource.push_dummy_image]
  function_name = "v2-1-agnostic-lambda"
  role          = aws_iam_role.lambda_exec.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.lambda_core.repository_url}:${var.image_tag}"

  environment {
    variables = {
      VERSION = "dev-manual"
    }
  }

  lifecycle {
    ignore_changes = [image_uri, environment]
  }
}

# Configure Function URL for the Lambda
resource "aws_lambda_function_url" "api_url" {
  function_name      = aws_lambda_function.api_core.function_name
  authorization_type = "NONE"
}

# Grant public access to the Function URL
resource "aws_lambda_permission" "public_url_access" {
  statement_id           = "FunctionURLPublicAccess"
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = aws_lambda_function.api_core.function_name
  principal              = "*"
  function_url_auth_type = "NONE"
}