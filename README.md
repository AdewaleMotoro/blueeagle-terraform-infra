# blueEagle Terraform Infra

My reconstruction of the Wandaprep Academy blueEagle Terraform project.

## Architecture

- **bootstrap/** — One-time setup creating the S3 bucket + DynamoDB table
  used for remote state and state locking.
- **modules/s3/** — Reusable S3 bucket module (versioning, AES256 encryption,
  public-access-block).
- **modules/iam/** — (planned) IAM roles and policies.
- **modules/vpc/** — (planned) VPC, subnets, internet gateway.

## Resources created

### Via bootstrap
- S3 bucket: `blueeagle-tfstate-morayo-2026` (region: us-east-1)
- DynamoDB table: `blueeagle-tfstate-lock-morayo-2026`

### Via root + modules
- S3 bucket: `blueeagle-dev-app`
  - Versioning: enabled
  - Encryption: AES256
  - Public access: blocked

## Progress

[x] Folder structure
- [x] Bootstrap (S3 + DynamoDB)
- [x] Root module
- [x] Modules: s3, iam
- [ ] Modules: vpc
- [x] Git hooks (pre-push validation)
- [ ] GitHub Actions CI/CD