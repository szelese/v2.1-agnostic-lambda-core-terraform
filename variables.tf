variable "aws_region" {
  type    = string
  default = "eu-west-2" // Update this default value to your desired AWS region
}

variable "github_repo" {
  type        = string
  description = "GitHub repository in the format 'owner/repo' (e.g., 'my-org/my-repo')"
  default = "szelese/v2.1-agnostic-lambda-core-terraform" // Update this default value to your actual GitHub repository
}