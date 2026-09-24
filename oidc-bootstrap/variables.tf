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

variable "state_lock_table_arn" {
  description = "ARN of the DynamoDB table used for Terraform state locking. The GitHub Actions role needs write access to this table to acquire/release locks during plan."
  type        = string
  default     = "arn:aws:dynamodb:us-east-1:556311299687:table/blueeagle-tfstate-lock-morayo-2026"
}

variable "state_bucket_arn" {
  description = "ARN of the S3 bucket storing Terraform state. GitHub Actions needs read access (for plan)."
  type        = string
  default     = "arn:aws:s3:::blueeagle-tfstate-morayo-2026"
}