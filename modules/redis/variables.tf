variable "cluster_name" {
  type        = string
  description = "Name of the tfe cluster."
}

variable "availability_zones" {
  type = list(any)
}

variable "subnet_ids" {
  type = list(any)
}

variable "vpc_security_group_ids" {
  type = list(any)
}