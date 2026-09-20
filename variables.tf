# variables.tf
#
# Input variables for the root module. These can be supplied via:
#   1. terraform.tfvars file (recommended)
#   2. -var="name=value" on the command line
#   3. TF_VAR_name environment variables
#   4. Interactive prompt (if no default provided)

variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "us-east-1"
}

variable "trainee_name" {
  description = "Your name or username. Used to namespace resources (must be globally unique for S3)."
  type        = string
}

variable "project_name" {
  description = "Name of the project. Used in resource naming and tags."
  type        = string
  default     = "blueeagle"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

//Prevents typos ("prod" vs "Prod" vs "production") from silently creating mislabeled resources