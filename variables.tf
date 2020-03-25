variable "cluster_name" {
  description = "Name of the tfe cluster."
  default     = "tfe-example"
}

variable "owner" {
  description = "Owner tag on all resources."
  default     = "myuser"
}

variable "key_name" {
  description = "Specify the AWS ssh key to use."
}

variable "private_key" {
  description = "SSH private key to provision the cluster instances."
}

variable "aws_region" {
  default = "eu-central-1"
}

variable "aws_azs" {
  type        = list
  description = "List of the availability zones to use."
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "amis" {
  type = map(string)
  default = {
    eu-central-1 = "ami-04cf43aca3e6f3de3" # centos 7
    #eu-north-1 = "ami-0affd4508a5d2481b" # centos 7
    #eu-central-1 = "ami-0b418580298265d5c" # ubuntu 18.04
  }
}

variable "instance_username" {
  default = "centos"
}

variable "num_tfe" {
  description = "Specify the amount of TFE servers. For redundancy you should have at least 2."
  default     = 1
}

variable "tfe_instance_type" {
  description = "TFE server instance type."
  default     = "m5.xlarge"
}

variable "tfe_release_sequence" {
  type        = number
  description = "Numerical identifier to pin a TFE release, e.g. 419."
  default     = 0
}

variable "domain" {
  description = "Root domain in route53"
  default     = "server.company.com"
}

variable "cert_domain" {
  type        = string
  description = "Domain to search for ACM certificate with (default is *.domain)"
  default     = ""
}

variable "update_route53" {
  type        = string
  description = "Indicate if route53 should be updated automatically."
  default     = true
}

variable "private_zone" {
  type        = string
  description = "Set to true if your route53 zone is private."
  default     = false
}

variable "tfe_admin_password" {
  description = "Password to be used for Replicated admin console."
  default     = "admin"
}

variable "tfe_enc_password" {
  description = "Password to be used for data encryption."
  default     = "admin"
}

variable "tfe_database_name" {
  description = "name of the initial database"
  default     = "tfe"
}

variable "tfe_database_username" {
  description = "username of the initial user"
  default     = "tfe"
}

locals {
  tfe_hostname = "${var.cluster_name}.${var.domain}"
}