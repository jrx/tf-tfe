provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 0.12"
  backend "remote" {}
}

resource "aws_instance" "tfe" {
  ami                         = var.amis[var.aws_region]
  instance_type               = var.tfe_instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = ["${aws_security_group.default.id}"]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.consul_profile.name
  count                       = var.num_tfe

  availability_zone = module.vpc.azs[count.index % length(module.vpc.azs)]
  subnet_id         = module.vpc.public_subnets[count.index % length(module.vpc.azs)]

  root_block_device {
    volume_size = 50
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir /home/${var.instance_username}/ansible",
    ]
  }
  provisioner "file" {
    source      = "./ansible/"
    destination = "/home/${var.instance_username}/ansible/"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install ansible",
      "cd ansible; ansible-playbook -c local -i \"localhost,\" -e 'HOSTNAME=${var.tfe_hostname} ADMIN_PASSWORD=${var.tfe_admin_password} ENC_PASSWORD=${var.tfe_enc_password} PRIVATE_ADDR=${self.private_ip} PUBLIC_ADDR=${self.public_ip} NODE_NAME=tfe-s${count.index}' tfe-server.yml",
    ]
  }

  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.instance_username
    private_key = var.private_key
  }

  tags = {
    Name  = "${var.cluster_name}-tfe-${count.index}"
    Owner = var.owner
    # Keep = ""
  }
}