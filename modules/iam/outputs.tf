# modules/iam/outputs.tf
#
# Values this module returns to whoever called it.

output "role_arn" {
  description = "ARN of the created IAM role."
  value       = aws_iam_role.app.arn
}

output "role_name" {
  description = "Name of the created IAM role."
  value       = aws_iam_role.app.name
}

output "instance_profile_name" {
  description = "Name of the instance profile (for attaching to EC2)."
  value       = aws_iam_instance_profile.app.name
}