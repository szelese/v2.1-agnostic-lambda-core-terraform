variable "aws_region" {
  type    = string
  default = "eu-west-2" // Update this default value to your desired AWS region and do not forget to update the region in providers in deploy.yml as well
}

variable "github_repo" {
  type        = string
  description = "GitHub repository"
  default = "v2.1-agnostic-lambda-core-terraform" // Update this default value to your actual GitHub repository
}

variable "notification_email" {
  type        = string
  description = "Email address to receive notifications (if applicable)"
  default     = "" // Update this default value to your actual email address or add to terraform.tfvars value to receive notifications about Lambda errors via SNS topic
}

variable "image_tag" {
  type        = string
  description = "Docker image tag(latest or commit hash). CI/CD update Lambda with this."
  default     = "latest"
}

variable "aws_account_id" {
  type        = string
  description = "AWS Account ID 12-digit format"
  default     = "" // Update this or add to terraform.tfvars value to your actual AWS Account ID
  validation {
    condition     = length(var.aws_account_id) == 12 && can(regex("^[0-9]+$", var.aws_account_id))
    error_message = "AWS Account ID must be a 12-digit number."
  }
}

variable "ecr_repository_name" {
  type        = string
  description = "ECR repository name"
  default     = "v2-agnostic-lambda-core" // Update this default value to your desired ECR repository name
}

variable "lambda_function_name" {
  type        = string
  description = "Lambda function name"
  default     = "v2-1-agnostic-lambda" // Update this default value to your desired Lambda function name
}

variable "github_owner" {
  type        = string
  description = "GitHub owner"
  default     = "szelese" // Update this default value to your GitHub username or organization
}

# GitHub App authentication (no PAT needed for local Terraform execution with these)
variable "github_app_id" {
  type        = string
  description = "GitHub App ID"
}

variable "github_app_installation_id" {
  type        = string
  description = "GitHub App Installation ID"
}

variable "github_app_pem_file_path" {
  type        = string
  description = "Path to the GitHub App private key PEM file"
}

variable "gha_deploy_role_name" {
  type    = string
  description = "Name of the GitHub Actions deploy role"
  default = "v2-1-gha-deploy-role"
}