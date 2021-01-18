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

  tags = {
    Name  = "${var.cluster_name}-tfe-${count.index}"
    Owner = var.owner
    # Keep = ""
  }
}

resource "null_resource" "ansible" {
  count = var.num_tfe

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/${var.instance_username}/ansible",
      "sudo yum -y install epel-release",
      "sudo yum -y install ansible",
    ]
  }
  provisioner "file" {
    source      = "./ansible/"
    destination = "/home/${var.instance_username}/ansible/"
  }
  provisioner "remote-exec" {
    inline = [
      "cd ansible; ansible-playbook -c local -i \"localhost,\" -e 'HOSTNAME=${local.tfe_hostname} RELEASE_SEQUENCE=${var.tfe_release_sequence} ADMIN_PASSWORD=${var.tfe_admin_password} ENC_PASSWORD=${var.tfe_enc_password} PRIVATE_ADDR=${element(aws_instance.tfe.*.private_ip, count.index)} PUBLIC_ADDR=${element(aws_instance.tfe.*.public_ip, count.index)} NODE_NAME=tfe-s${count.index} DATABASE_NAME=${module.rds.database_name} DATABASE_ENDPOINT=${module.rds.endpoint} DATABASE_PASSWORD=${module.rds.database_password} DATABASE_USERNAME=${var.tfe_database_username} REDIS_HOST=${module.redis.redis_host} REDIS_PORT=${module.redis.redis_port} REDIS_PASS=${module.redis.redis_pass} S3_BUCKET=${module.s3.bucket_id} S3_REGION=${module.s3.region}' tfe-server.yml",
    ]
  }

  connection {
    host        = coalesce(element(aws_instance.tfe.*.public_ip, count.index), element(aws_instance.tfe.*.private_ip, count.index))
    type        = "ssh"
    user        = var.instance_username
    private_key = var.private_key
  }

  triggers = {
    always_run = timestamp()
  }
}