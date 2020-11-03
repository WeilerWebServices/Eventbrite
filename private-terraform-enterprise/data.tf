data "aws_route53_zone" "pes" {
  name         = var.route53_zone
  private_zone = false
}

data "aws_s3_bucket" "source" {
  bucket = var.source_bucket_name
}

# user_data script that will install PTFE
data "template_file" "user_data" {
  template = file(
    "${path.module}/user-data-${var.linux}-${var.operational_mode}.tpl",
  )

  vars = {
    hostname                  = var.hostname
    public_ip                 = var.public_ip
    ptfe_admin_password       = var.ptfe_admin_password
    ca_certs                  = var.ca_certs
    installation_type         = var.installation_type
    production_type           = var.production_type
    capacity_concurrency      = var.capacity_concurrency
    capacity_memory           = var.capacity_memory
    enc_password              = var.enc_password
    enable_metrics_collection = var.enable_metrics_collection
    extra_no_proxy            = var.extra_no_proxy
    pg_dbname                 = var.pg_dbname
    pg_extra_params           = var.pg_extra_params
    pg_netloc                 = module.database.db_endpoint
    pg_password               = var.pg_password
    pg_user                   = var.pg_user
    placement                 = var.placement
    aws_instance_profile      = var.aws_instance_profile
    s3_bucket                 = var.s3_bucket
    s3_region                 = var.s3_region
    s3_sse                    = var.s3_sse
    s3_sse_kms_key_id         = var.s3_sse_kms_key_id
    vault_path                = var.vault_path
    vault_store_snapshot      = var.vault_store_snapshot
    tbw_image                 = var.tbw_image
    custom_image_tag          = var.custom_image_tag
    source_bucket_name        = var.source_bucket_name
    ptfe_license              = var.ptfe_license
    operational_mode          = var.operational_mode
    airgap_bundle             = var.airgap_bundle
    replicated_bootstrapper   = var.replicated_bootstrapper
    create_first_user_and_org = var.create_first_user_and_org
    initial_admin_username    = var.initial_admin_username
    initial_admin_email       = var.initial_admin_email
    initial_admin_password    = var.initial_admin_password
    initial_org_name          = var.initial_org_name
    initial_org_email         = var.initial_org_email
  }
}
