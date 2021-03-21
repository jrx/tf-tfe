variable "ami_name" {
  type    = string
  default = "my-custom-ami"
}

variable "aws_access_key" {
  type    = string
  default = "${env("AWS_ACCESS_KEY_ID")}"
}

variable "aws_secret_key" {
  type    = string
  default = "${env("AWS_SECRET_ACCESS_KEY")}"
}

variable "aws_session_token" {
  type    = string
  default = "${env("AWS_SESSION_TOKEN")}"
}

variable "aws_region" {
  type    = string
  default = "eu-north-1"
}

variable "owner" {
  type    = string
  default = "my-user"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "centos" {
  access_key                  = "${var.aws_access_key}"
  ami_name                    = "packer centos ${local.timestamp}"
  associate_public_ip_address = true
  force_delete_snapshot       = true
  force_deregister            = true
  instance_type               = "m5.xlarge"
  region                      = "${var.aws_region}"
  secret_key                  = "${var.aws_secret_key}"
  source_ami_filter {
    filters = {
      name                = "*CentOS Linux 7 x86_64 HVM EBS ENA*"
      product-code        = "aw0evgkw8e5c1q413zgy5pjce"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["679593333241"]
  }
  ssh_username = "centos"
  tags = {
    Name       = "CentOS 7 - TFE (jrx-dev)"
    OS         = "centos"
    OS-Version = "7"
    Owner      = "${var.owner}"
  }
  token = "${var.aws_session_token}"
}

build {
  sources = ["source.amazon-ebs.centos"]

  provisioner "ansible" {
    playbook_file = "./ansible/tfe-server.yml"
  }
}