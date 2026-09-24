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
        "repo:${var.github_org}/${var.github_repo}:*",
        "repo:${var.github_org}@*/${var.github_repo}@*:*",
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

# ---
# State locking policy — the role needs to WRITE lock records to DynamoDB.
# ReadOnlyAccess alone doesn't cover this. We scope it tightly to the
# one specific lock table used by Terraform state.
# ---
data "aws_iam_policy_document" "state_lock" {
  statement {
    sid    = "TerraformStateLockManagement"
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:DescribeTable",
    ]
    resources = [var.state_lock_table_arn]
  }
}

resource "aws_iam_policy" "state_lock" {
  name        = "${var.role_name}-state-lock"
  description = "Allow GitHub Actions to acquire/release Terraform state locks"
  policy      = data.aws_iam_policy_document.state_lock.json
}

resource "aws_iam_role_policy_attachment" "state_lock" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.state_lock.arn
}