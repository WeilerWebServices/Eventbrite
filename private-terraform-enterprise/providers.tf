provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  assume_role {
    role_arn = "arn:aws:iam::${var.shared_svcs_account_number}:role/${var.shared_svcs_admin_role}"
  }
}
