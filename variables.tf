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

variable "tfe_hostname" {
  description = "TFE public dns name to access the frontend."
  default     = "server.company.com"
}

variable "tfe_admin_password" {
  description = "Password to be used for Replicated admin console."
  default     = "admin"
}

variable "tfe_enc_password" {
  description = "Password to be used for data encryption."
  default     = "admin"
}