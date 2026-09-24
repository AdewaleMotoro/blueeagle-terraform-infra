# oidc-bootstrap/backend.tf
#
# Stores this config's state in the same S3 bucket as the root module,
# but under a different key. This isolates the OIDC bootstrap state
# from the application infrastructure state.

terraform {
  backend "s3" {
    bucket         = "blueeagle-tfstate-morayo-2026"
    key            = "oidc-bootstrap/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "blueeagle-tfstate-lock-morayo-2026"
    encrypt        = true
  }
}