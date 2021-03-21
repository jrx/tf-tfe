provider "aws" {
  region = var.aws_region
}

module "net" {
  source       = "./modules/net"
  cluster_name = var.cluster_name
  owner        = var.owner
  aws_azs      = var.aws_azs
}

module "rds" {
  source                 = "./modules/rds"
  cluster_name           = var.cluster_name
  tfe_database_name      = var.tfe_database_name
  tfe_database_username  = var.tfe_database_username
  subnet_ids             = module.net.public_subnets
  vpc_security_group_ids = module.net.vpc_security_group_db
}
module "redis" {
  source                 = "./modules/redis"
  availability_zones     = var.aws_azs
  cluster_name           = var.cluster_name
  subnet_ids             = module.net.public_subnets
  vpc_security_group_ids = module.net.vpc_security_group_redis
}

module "s3" {
  source       = "./modules/s3"
  cluster_name = var.cluster_name
}

locals {
  tfe_hostname = "${var.cluster_name}.${var.domain}"
}

module "route53" {
  source         = "./modules/route53"
  domain         = var.domain
  cert_domain    = var.cert_domain
  update_route53 = var.update_route53
  private_zone   = var.private_zone
  ips            = aws_instance.tfe.*.public_ip
  hostname       = local.tfe_hostname
}

resource "aws_instance" "tfe" {
  ami                         = var.amis[var.aws_region]
  instance_type               = var.tfe_instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = module.net.vpc_security_group_default
  iam_instance_profile        = aws_iam_instance_profile.tfe_objects_profile.name
  associate_public_ip_address = true
  count                       = var.num_tfe

  availability_zone = module.net.azs[count.index % length(module.net.azs)]
  subnet_id         = module.net.public_subnets[count.index % length(module.net.azs)]

  root_block_device {
    volume_size = 50
  }

  user_data = data.template_file.user_data[count.index].rendered

  tags = {
    Name  = "${var.cluster_name}-tfe-${count.index}"
    Owner = var.owner
    # Keep = ""
  }
}

data "template_file" "user_data" {
  count = var.num_tfe

  template = format("%s\n%s\n%s",
    file("${path.module}/templates/replicated.sh.tpl"),
    file("${path.module}/templates/settings.sh.tpl"),
    file("${path.module}/templates/tfe.sh.tpl")
  )

  vars = {
    tfe_admin_password   = var.tfe_admin_password
    tfe_hostname         = local.tfe_hostname
    tfe_release_sequence = var.tfe_release_sequence
    enc_password         = var.tfe_enc_password
    database_name        = module.rds.database_name
    database_endpoint    = module.rds.endpoint
    database_password    = module.rds.database_password
    database_username    = var.tfe_database_username
    redis_host           = module.redis.redis_host
    redis_port           = module.redis.redis_port
    redis_pass           = module.redis.redis_pass
    s3_bucket            = module.s3.bucket_id
    s3_region            = module.s3.region
  }
}