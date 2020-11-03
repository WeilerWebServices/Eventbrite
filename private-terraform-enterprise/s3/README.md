TFE Install S3 Backend
======================

Instantiate a private S3 bucket (source bucket) to which the TFE software, license, and settings files can be uploaded and a KMS key used to encrypt the bucket.

See [documentation](https://confluence.evbhome.com/display/SRE/Install+Terraform+Enterprise) for more details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket\_name | Name of the PTFE source bucket to create | `any` | n/a | yes |
| namespace | Unique name to use for DNS and resource naming | `any` | n/a | yes |
| profile | AWS CLI profile for terraform to execute with | `string` | n/a | yes |
| region | Region to use for the AWS provider | `string` | n/a | yes |
| shared\_svcs\_account\_number | Account number for the shared services account. Needed because we are jumping through an assumed role. | `string` | n/a | yes |
| shared\_svcs\_admin\_role | Name of the admin role establishing the trust between the master payer account and the shared services account | `string` | `"tlz_organization_account_access_role"` | no |

## Outputs

| Name | Description |
|------|-------------|
| kms\_id | n/a |