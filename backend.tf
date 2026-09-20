# backend.tf
#
# This file tells Terraform to store the root module's state in the S3
# bucket + DynamoDB table that the bootstrap/ folder created.
#
# The values are filled in from the bootstrap outputs, but we use
# variables where possible for flexibility. Since backend blocks
# CANNOT use variables, the values here must be literal strings.
#
# These match the bootstrap outputs:
#   bucket         = "blueeagle-tfstate-morayo-2026"
#   dynamodb_table = "blueeagle-tfstate-lock-morayo-2026"
#   region         = "us-east-1"

terraform {
  backend "s3" {
    bucket         = "blueeagle-tfstate-morayo-2026"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "blueeagle-tfstate-lock-morayo-2026"
    encrypt        = true
  }
}