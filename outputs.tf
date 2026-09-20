# outputs.tf
#
# Root module outputs - values exposed to the user or to other
# configurations (e.g., CI/CD pipelines) after `terraform apply`.
#
# As we add child modules, we'll surface useful values here
# (bucket names, VPC IDs, etc.).

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