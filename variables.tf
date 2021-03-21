variable "cluster_name" {
  type        = string
  description = "Name of the tfe cluster."
  default     = "tfe-example"
}

variable "owner" {
  type        = string
  description = "Owner tag on all resources."
  default     = "myuser"
}

variable "key_name" {
  type        = string
  description = "Specify the AWS ssh key to use."
}

variable "aws_region" {
  type    = string
  default = "eu-north-1"
}

variable "aws_azs" {
  type        = list(any)
  description = "List of the availability zones to use."
  default     = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
}

variable "amis" {
  type = map(string)
  default = {
    eu-north-1 = "ami-02dae9b8dca8dafb7" # centos 7.9
  }
}

variable "instance_username" {
  type    = string
  default = "centos"
}

variable "num_tfe" {
  type        = number
  description = "Specify the amount of TFE servers. For redundancy you should have 2."
  default     = 2
}

variable "tfe_instance_type" {
  type        = string
  description = "TFE server instance type."
  default     = "m5.xlarge"
}

variable "tfe_release_sequence" {
  type        = number
  description = "Numerical identifier to pin a TFE release, e.g. 419."
  default     = 0
}

variable "domain" {
  type        = string
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
  type        = string
  description = "Password to be used for Replicated admin console."
  default     = "admin"
}

variable "tfe_enc_password" {
  type        = string
  description = "Password to be used for data encryption."
  default     = "admin"
}

variable "tfe_database_name" {
  type        = string
  description = "name of the initial database"
  default     = "tfe"
}

variable "tfe_database_username" {
  type        = string
  description = "username of the initial user"
  default     = "tfe"
}