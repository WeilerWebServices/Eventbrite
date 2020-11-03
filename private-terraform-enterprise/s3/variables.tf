variable "profile" {
  type        = string
  description = "AWS CLI profile for terraform to execute with"
}

variable "region" {
  type        = string
  description = "Region to use for the AWS provider"
}

variable "namespace" {
  description = "Unique name to use for DNS and resource naming"
}

variable "bucket_name" {
  description = "Name of the TFE source bucket to create"
}

variable "shared_svcs_account_number" {
  type        = string
  description = "Account number for the shared services account. Needed because we are jumping through an assumed role."
}

variable "shared_svcs_admin_role" {
  description = "Name of the admin role establishing the trust between the master payer account and the shared services account"
  type        = string
  default     = "tlz_organization_account_access_role"
}
