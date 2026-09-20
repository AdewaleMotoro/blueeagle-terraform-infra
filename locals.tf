# locals.tf
#
# Computed values used across the root module. "locals" (as opposed to
# "variables") are not inputs - they're derived inside the configuration.
# Using locals avoids repeating the same expression in many places.

locals {
  # A consistent naming prefix used across all resources.
  # Example: "blueeagle-dev"
  name_prefix = "${var.project_name}-${var.environment}"

  # Common tags merged with provider default_tags.
  # Resource-level tags can override or extend these.
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.trainee_name
    ManagedBy   = "Terraform"
  }
}