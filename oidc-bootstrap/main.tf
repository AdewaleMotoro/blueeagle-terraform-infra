# oidc-bootstrap/main.tf
#
# Creates the AWS-side trust for GitHub Actions OIDC.
#
# Two resources:
#   1. An OIDC identity provider that trusts tokens issued by GitHub
#      for this repo. Once per AWS account.
#   2. An IAM role that GitHub Actions workflows can assume, with
#      permissions to read AWS resources (for terraform plan).

# ---
# Data source: current AWS account ID (used to build the role ARN)
# ---
data "aws_caller_identity" "current" {}

# ---
# OIDC Identity Provider — AWS trusts tokens from GitHub
# ---
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  # GitHub's root CA thumbprint.
  # AWS recommends at least one valid thumbprint. This is the canonical one.
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd",
  ]

  tags = {
    Name      = "github-actions-oidc"
    ManagedBy = "Terraform"
    Project   = "blueEagle"
  }
}

# ---
# IAM role — GitHub Actions will assume this
# ---
data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    # Restrict to a specific repo. The ':*' allows any branch, tag,
    # or environment within that repo.
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.github_org}/${var.github_repo}:*"
      ]
    }

    # Restrict to tokens intended for AWS STS
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json

  tags = {
    Name      = var.role_name
    ManagedBy = "Terraform"
    Project   = "blueEagle"
  }
}

# ---
# Attach the permissions policy to the role
# ---
resource "aws_iam_role_policy_attachment" "github_actions" {
  role       = aws_iam_role.github_actions.name
  policy_arn = var.permissions_policy_arn
}