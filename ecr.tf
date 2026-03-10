resource "aws_ecr_repository" "lambda_core" {
  name                 = "v2-agnostic-lambda-core"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}