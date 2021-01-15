variable "cluster_name" {
  type        = string
  description = "Name of the tfe cluster."
}

variable "tfe_database_name" {
  type        = string
  description = "name of the initial database"
}

variable "tfe_database_username" {
  type        = string
  description = "username of the initial user"
}

variable "subnet_ids" {
  type = list(any)
}

variable "vpc_security_group_ids" {
  type = list(any)
}