# IAM Role with Attached Least-Privilege Policy

This blueprint provisions a single IAM Role together with a customer-managed
IAM Policy that is attached to it. The policy is never created standalone —
`aws_iam_role_policy_attachment` guarantees it is always bound to a principal.

## What this creates

- `aws_iam_role.this` — the role, with a trust (assume-role) policy built
  from `data.aws_iam_policy_document.assume_role`.
- `aws_iam_policy.this` — a least-privilege permissions policy built from
  `data.aws_iam_policy_document.permissions`.
- `aws_iam_role_policy_attachment.this` — binds the policy to the role.

## Security defaults

- **Trust policy**: by default only the AWS service principals listed in
  `trusted_service_principals` (default: `ec2.amazonaws.com`) can assume the
  role. Cross-account assumption via `trusted_account_arns` is disabled
  (empty list) unless explicitly configured, and when enabled it supports an
  `sts:ExternalId` condition via `external_id` to reduce confused-deputy risk.
- **Permissions policy**: no wildcard (`*`) actions or resources. The example
  policy grants only `s3:ListBucket` on the bucket ARN and `s3:GetObject` on
  objects within a single, explicitly named bucket (`bucket_name`). Adjust
  `data.aws_iam_policy_document.permissions` in `main.tf` for your actual use
  case, keeping actions and resources as narrow as possible.
- **Permissions boundary**: optionally set `permissions_boundary_arn` to cap
  the maximum permissions the role can ever have.
- **Session duration**: bounded between 1 and 12 hours via
  `max_session_duration` (AWS limits).
- **Tagging**: all resources are tagged with `ManagedBy = "Terraform"` plus
  any tags supplied via `tags`.

## Usage

```
terraform init -backend=false
terraform validate
terraform plan \
  -var="role_name=my-role" \
  -var="policy_name=my-policy" \
  -var="bucket_name=my-actual-bucket"
```

No remote backend is configured and no real credentials are required to run
`init` or `validate`. Applying against a real AWS account requires valid AWS
credentials configured through the standard provider mechanisms (environment
variables, shared config, etc.) — none are hardcoded here.

## Key variables

| Variable                      | Purpose                                               |
|--------------------------------|--------------------------------------------------------|
| `role_name` / `policy_name`    | Names of the role and policy                          |
| `trusted_service_principals`   | AWS services allowed to assume the role               |
| `trusted_account_arns`         | External account/role/user ARNs allowed cross-account assumption |
| `external_id`                  | Optional condition to harden cross-account trust       |
| `permissions_boundary_arn`     | Optional cap on maximum role permissions               |
| `bucket_name`                  | S3 bucket the policy grants least-privilege read access to |
| `max_session_duration`         | Assume-role session length in seconds (3600–43200)     |
| `tags`                         | Extra tags merged onto both resources                  |

## Outputs

- `role_name`, `role_arn`, `role_id`
- `policy_name`, `policy_arn`
- `policy_attachment_id` — confirms the policy is attached to the role

## Customizing for a real workload

Replace the S3 read-only example in `data.aws_iam_policy_document.permissions`
with the exact actions and resource ARNs your workload needs. Avoid
`Resource = "*"` and avoid wide action wildcards (e.g. `s3:*`); enumerate only
the actions actually required.
