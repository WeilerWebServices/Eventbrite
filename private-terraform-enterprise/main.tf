resource "aws_security_group" "ptfe" {
  name        = "${var.namespace}-sg"
  description = "${var.namespace} security group"
  vpc_id      = var.vpc_id

  ingress {
    protocol  = -1
    from_port = 0
    to_port   = 0
    self      = true
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 8800
    to_port     = 8800
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Connect to Consul on eb prod
  egress {
    protocol    = "tcp"
    from_port   = 8500
    to_port     = 8500
    cidr_blocks = split(",", var.eb_prod_priv_cidrs)
  }

  # Connect to Consul on eb stage
  egress {
    protocol    = "tcp"
    from_port   = 8500
    to_port     = 8500
    cidr_blocks = split(",", var.eb_stage_priv_cidrs)
  }

  # Connect to Consul on eb qa
  egress {
    protocol    = "tcp"
    from_port   = 8500
    to_port     = 8500
    cidr_blocks = split(",", var.eb_qa_priv_cidrs)
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "database" {
  source                  = "./database"
  namespace               = var.namespace
  subnet_ids              = split(",", var.db_subnet_ids)
  vpc_security_group_ids  = aws_security_group.ptfe.id
  database_name           = var.pg_dbname
  database_username       = var.pg_user
  database_pwd            = var.pg_password
  database_storage        = var.database_storage
  database_instance_class = var.database_instance_class
  database_multi_az       = var.database_multi_az
}

module "pes" {
  source                 = "./pes"
  namespace              = var.namespace
  aws_instance_ami       = var.aws_instance_ami
  aws_instance_type      = var.aws_instance_type
  public_ip              = var.public_ip
  vpc_id                 = var.vpc_id
  ptfe_subnet_ids        = split(",", var.ptfe_subnet_ids)
  alb_subnet_ids         = split(",", var.alb_subnet_ids)
  vpc_security_group_ids = aws_security_group.ptfe.id
  user_data              = data.template_file.user_data.rendered
  ssh_key_name           = var.ssh_key_name
  zone_id                = data.aws_route53_zone.pes.zone_id
  alb_internal           = var.alb_internal
  hostname               = var.hostname
  owner                  = var.owner
  ttl                    = var.ttl
  ssl_certificate_arn    = var.ssl_certificate_arn
  ptfe_bucket_name       = var.s3_bucket
  kms_key_id             = var.s3_sse_kms_key_id
  source_bucket_id       = data.aws_s3_bucket.source.id
  create_second_instance = var.create_second_instance
}
