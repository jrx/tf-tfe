resource "aws_security_group" "default" {
  name   = "${var.cluster_name}_default"
  vpc_id = data.terraform_remote_state.vpc.outputs.aws_vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8800
    to_port     = 8800
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9443
    to_port     = 9443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "sg-${var.cluster_name}"
    Owner = var.owner
  }
}

resource "aws_security_group" "db_access" {
  vpc_id = data.terraform_remote_state.vpc.outputs.aws_vpc_id

  ingress {
    description = "TFE ingress to rds"
    protocol    = "tcp"
    from_port   = "5432"
    to_port     = "5432"

    cidr_blocks = ["10.0.0.0/16"]
  }

  tags = {
    Name  = "sg-${var.cluster_name}"
    Owner = var.owner
  }
}

resource "aws_security_group" "redis_access" {
  vpc_id = data.terraform_remote_state.vpc.outputs.aws_vpc_id

  ingress {
    description = "TFE ingress to redis"
    protocol    = "tcp"
    from_port   = 7480
    to_port     = 7480

    cidr_blocks = ["10.0.0.0/16"]
  }

  tags = {
    Name  = "sg-${var.cluster_name}"
    Owner = var.owner
  }
}

data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    workspaces = {
      name = "net-dev"
    }
    hostname     = "app.terraform.io"
    organization = "jrx"
  }
}