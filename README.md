# blueEagle Terraform Infra

My reconstruction of the Wandaprep Academy blueEagle Terraform project.

## Structure

- `bootstrap/` - One-time setup: S3 + DynamoDB for remote state
- `modules/` - Reusable modules (iam, s3, vpc) - TBD
- `scripts/` - Helper scripts - TBD
- `.githooks/` - Pre-push validation - TBD
- `.github/workflows/` - GitHub Actions CI/CD - TBD

## Bootstrap outputs

- S3 bucket:   `blueeagle-tfstate-morayo-2026` (region: us-east-1)
- DynamoDB:    `blueeagle-tfstate-lock-morayo-2026`

## Progress

- [x] Folder structure
- [x] Bootstrap (S3 + DynamoDB)
- [ ] Root module
- [ ] Modules (iam, s3, vpc)
- [ ] Scripts & hooks
- [ ] GitHub Actions