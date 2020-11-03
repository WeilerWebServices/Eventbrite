TFE Install
===========

Deploy the external PostgreSQL database and S3 bucket used in the External Services operational mode of TFE along with the primary and optional secondary EC2 instances that will run TFE, an Application Load Balancer and associated resources, and some required IAM resources.

See [documentation](https://confluence.evbhome.com/display/SRE/Install+Terraform+Enterprise) for more details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| airgap\_bundle | S3 bucket object container airgap bundle | `string` | `""` | no |
| alb\_internal | whether ALB is internal or not | `bool` | `false` | no |
| alb\_subnet\_ids | Subnet IDs of DB subnets in VPC | `any` | n/a | yes |
| aws\_instance\_ami | Amazon Machine Image ID | `any` | n/a | yes |
| aws\_instance\_profile | use credentials from the AWS instance profile | `string` | `"1"` | no |
| aws\_instance\_type | EC2 instance type | `any` | n/a | yes |
| aws\_profile | AWS CLI profile for terraform to execute with | `string` | n/a | yes |
| aws\_region | Region to use for the AWS provider | `string` | n/a | yes |
| ca\_certs | custom certificate authority (CA) bundle | `string` | `""` | no |
| capacity\_concurrency | number of concurrent plans and applies; defaults to 10 | `string` | `"10"` | no |
| capacity\_memory | The maximum amount of memory (in megabytes) that a Terraform plan or apply can use on the system; defaults to 256 | `string` | `"256"` | no |
| create\_first\_user\_and\_org | whether to create the first site admin and org | `any` | n/a | yes |
| create\_second\_instance | whether to create second PTFE instance | `string` | `"0"` | no |
| custom\_image\_tag | alternative Terraform worker image name and tag | `string` | `"hashicorp/build-worker:now"` | no |
| database\_instance\_class | instance class for RDS database | `string` | `"db.t2.medium"` | no |
| database\_multi\_az | boolean indicating whether to run multi-az RDS | `string` | `"false"` | no |
| database\_storage | allocated storage for RDS database | `string` | `"10"` | no |
| db\_subnet\_ids | Subnet IDs of DB subnets in VPC | `any` | n/a | yes |
| eb\_prod\_priv\_cidrs | CIDRs blocks of EB legacy account prod private subnets | `any` | n/a | yes |
| eb\_qa\_priv\_cidrs | CIDRs blocks of EB legacy account QA private subnets | `any` | n/a | yes |
| eb\_stage\_priv\_cidrs | CIDRs blocks of EB legacy account stage private subnets | `any` | n/a | yes |
| enable\_metrics\_collection | whether PTFE's internal metrics collection should be enabled | `string` | `"true"` | no |
| enc\_password | Set the encryption password for the install | `any` | n/a | yes |
| extra\_no\_proxy | a comma separated list of hosts to exclude from proxying | `string` | `""` | no |
| hostname | the DNS hostname you will use to access PTFE | `string` | `""` | no |
| initial\_admin\_email | email of initial site admin user in PTFE | `any` | n/a | yes |
| initial\_admin\_password | username of initial site admin user in PTFE | `any` | n/a | yes |
| initial\_admin\_username | username of initial site admin user in PTFE | `any` | n/a | yes |
| initial\_org\_email | email of initial organization in PTFE | `any` | n/a | yes |
| initial\_org\_name | name of initial organization in PTFE | `any` | n/a | yes |
| installation\_type | PTFE deployment mode | `string` | `"production"` | no |
| linux | ubuntu, rhel, or centos | `string` | `"ubuntu"` | no |
| namespace | Unique name to use for DNS and resource naming | `any` | n/a | yes |
| operational\_mode | whether installation is online or airgapped | `string` | `"online"` | no |
| owner | EC2 instance owner | `string` | `""` | no |
| pg\_dbname | Name of PostgreSQL database | `string` | `"ptfe"` | no |
| pg\_extra\_params | extra parameters for PostgreSQL | `string` | `"sslmode=require"` | no |
| pg\_password | Password for PostgreSQL database | `any` | n/a | yes |
| pg\_user | Name of PostgreSQL database user | `string` | `"ptfe"` | no |
| placement | Set to placement\_s3 for S3 | `string` | `"placement_s3"` | no |
| production\_type | external or disk | `string` | `"external"` | no |
| ptfe\_admin\_password | password for PTFE admin console (at port 8800) | `any` | n/a | yes |
| ptfe\_license | key of license file within the source S3 bucket | `any` | n/a | yes |
| ptfe\_subnet\_ids | Subnet IDs of subnets for EC2 instances in VPC | `any` | n/a | yes |
| public\_ip | should ec2 instance have public ip? | `bool` | `true` | no |
| replicated\_bootstrapper | S3 bucket object containing replicated bootstrapper replicated.tar.gz | `string` | `""` | no |
| route53\_zone | name of Route53 zone to use | `any` | n/a | yes |
| s3\_bucket | Name of the S3 bucket | `any` | n/a | yes |
| s3\_region | region of the S3 bucket | `any` | n/a | yes |
| s3\_sse | enables server-side encryption of objects in S3. | `string` | `"aws:kms"` | no |
| s3\_sse\_kms\_key\_id | An optional KMS key for use when S3 server-side encryption is enabled | `any` | n/a | yes |
| shared\_svcs\_account\_number | Account number for the shared services account. Needed because we are jumping through an assumed role. | `string` | n/a | yes |
| shared\_svcs\_admin\_role | Name of the admin role establishing the trust between the master payer account and the shared services account | `string` | `"tlz_organization_account_access_role"` | no |
| source\_bucket\_name | Name of the S3 PTFE source bucket containing PTFE license file, airgap bundle, replicated tar file, and settings files | `any` | n/a | yes |
| ssh\_key\_name | AWS key pair name to install on the EC2 instance | `any` | n/a | yes |
| ssl\_certificate\_arn | ARN of an SSL certificate uploaded to IAM or AWS Certificate Manager for use with PTFE ELB | `any` | n/a | yes |
| tbw\_image | whether to use standard or custom Terraform worker image | `string` | `"default_image"` | no |
| ttl | EC2 instance TTL | `string` | `"-1"` | no |
| vault\_path | Path on the host system to store the vault files | `string` | `"/var/lib/tfe-vault"` | no |
| vault\_store\_snapshot | whether vault files should be stored in snapshots | `string` | `"1"` | no |
| vpc\_id | ID of VPC | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| db\_endpoint | n/a |
| ptfe\_fqdn | n/a |
| ptfe\_private\_dns | n/a |
| ptfe\_private\_ip | n/a |
| ptfe\_public\_dns | n/a |
| ptfe\_public\_ip | n/a |