variable "aws_region" {
  type    = string
  default = "eu-west-2" // Update this default value to your desired AWS region and do not forget to update the region in providers in deploy.yml as well
}

variable "github_repo" {
  type        = string
  description = "GitHub repository in the format 'owner/repo' (e.g., 'my-org/my-repo')"
  default = "szelese/v2.1-agnostic-lambda-core-terraform" // Update this default value to your actual GitHub repository
}

variable "notification_email" {
  type        = string
  description = "Email address to receive notifications (if applicable)"
  default     = "test.123@gmail.com" // Update this default value to your actual email address
}

variable "image_tag" {
  type        = string
  description = "Docker image tag(latest or commit hash). CI/CD update Lambda with this."
  default     = "latest"
}