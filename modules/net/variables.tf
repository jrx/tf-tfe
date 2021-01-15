variable "cluster_name" {
  type        = string
  description = "Name of the tfe cluster."
}

variable "owner" {
  type        = string
  description = "Owner tag on all resources."
}

variable "aws_azs" {
  type        = list(any)
  description = "List of the availability zones to use."
}