# oidc-bootstrap/outputs.tf
#
# Values needed by the GitHub Actions workflow.

output "role_arn" {
  description = "ARN of the IAM role GitHub Actions assumes."
  value       = aws_iam_role.github_actions.arn
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC identity provider."
  value       = aws_iam_openid_connect_provider.github.arn
}

output "account_id" {
  description = "AWS account ID."
  value       = data.aws_caller_identity.current.account_id
}