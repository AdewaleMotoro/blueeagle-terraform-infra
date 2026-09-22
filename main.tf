# main.tf
#
# Root module — wires together the child modules.
#
# Three modules are called:
#   - app_s3   : creates an S3 bucket for application data
#   - app_iam  : creates an IAM role with read-only access to that bucket
#   - app_vpc  : creates a VPC with public and private subnets
#
# Cross-module references:
#   - module.app_iam receives module.app_s3.bucket_arn as input
#   Terraform uses these references to determine creation order.

# ---
# S3 module — creates the application bucket
# ---
module "app_s3" {
  source       = "./modules/s3"
  name_prefix  = local.name_prefix
  trainee_name = var.trainee_name
  tags         = local.common_tags
}

# ---
# IAM module — creates a role with read-only access to the app bucket
# ---
module "app_iam" {
  source        = "./modules/iam"
  name_prefix   = local.name_prefix
  trainee_name  = var.trainee_name
  tags          = local.common_tags
  s3_bucket_arn = module.app_s3.bucket_arn
}

# ---
# VPC module — creates a VPC with public and private subnets
# ---
module "app_vpc" {
  source       = "./modules/vpc"
  name_prefix  = local.name_prefix
  trainee_name = var.trainee_name
  tags         = local.common_tags
  # vpc_cidr and az_count use defaults from the module (10.0.0.0/16, 2 AZs)
}