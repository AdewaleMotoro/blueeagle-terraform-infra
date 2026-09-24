# oidc-bootstrap/variables.tf
#
# Inputs for the OIDC bootstrap.

variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "us-east-1"
}

variable "github_org" {
  description = "GitHub username or organization that owns the repo."
  type        = string
  default     = "AdewaleMotoro"
}

variable "github_repo" {
  description = "GitHub repository name."
  type        = string
  default     = "blueeagle-terraform-infra"
}

variable "role_name" {
  description = "Name of the IAM role GitHub Actions will assume."
  type        = string
  default     = "github-actions-terraform"
}

variable "permissions_policy_arn" {
  description = "AWS managed policy ARN to attach to the GitHub Actions role."
  type        = string
  default     = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}