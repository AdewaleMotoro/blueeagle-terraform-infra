# providers.tf
#
# Declares Terraform version constraints and the AWS provider.
# This is the standard place to put provider configuration -
# separate from main.tf so it's easy to find.

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = "blueEagle"
      ManagedBy = "Terraform"
      Owner     = var.trainee_name
    }
  }
}