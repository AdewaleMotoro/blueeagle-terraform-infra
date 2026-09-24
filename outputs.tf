# outputs.tf
#
# Root module outputs - values exposed to the user or to other
# configurations (e.g., CI/CD pipelines) after `terraform apply`.

# ---
# Configuration context
# ---
output "region" {
  description = "AWS region used by this configuration."
  value       = var.aws_region
}

output "environment" {
  description = "Environment name (dev, staging, prod)."
  value       = var.environment
}

output "name_prefix" {
  description = "Common naming prefix used across all resources."
  value       = local.name_prefix
}

output "trainee_name" {
  description = "Owner of the resources (your name/username)."
  value       = var.trainee_name
}

# --- 
# S3 module outputs
# ---
output "app_bucket_name" {
  description = "Name of the application S3 bucket."
  value       = module.app_s3.bucket_name
}

output "app_bucket_arn" {
  description = "ARN of the application S3 bucket."
  value       = module.app_s3.bucket_arn
}

# ---
# IAM module outputs
# ---
output "app_role_arn" {
  description = "ARN of the application IAM role."
  value       = module.app_iam.role_arn
}

output "app_role_name" {
  description = "Name of the application IAM role."
  value       = module.app_iam.role_name
}

output "app_instance_profile_name" {
  description = "Name of the IAM instance profile for EC2."
  value       = module.app_iam.instance_profile_name
}

# ---
# VPC module outputs
# ---
output "vpc_id" {
  description = "ID of the created VPC."
  value       = module.app_vpc.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC."
  value       = module.app_vpc.vpc_cidr
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = module.app_vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets."
  value       = module.app_vpc.private_subnet_ids
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway."
  value       = module.app_vpc.internet_gateway_id
}


# ---
# EC2 module outputs
# ---
output "ec2_instance_id" {
  description = "ID of the EC2 instance."
  value       = module.app_ec2.instance_id
}

output "ec2_public_ip" {
  description = "Public IP of the EC2 instance."
  value       = module.app_ec2.public_ip
}

output "ec2_ssh_command" {
  description = "SSH command to connect (replace <key> with your .pem path)."
  value       = module.app_ec2.ssh_command
}