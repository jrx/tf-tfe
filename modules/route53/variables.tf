variable "domain" {
  type        = string
  description = "Root domain in route53"
}

variable "cert_domain" {
  type        = string
  description = "Domain to search for ACM certificate with (default is *.domain)"
}

variable "update_route53" {
  type        = string
  description = "Indicate if route53 should be updated automatically."
}

variable "private_zone" {
  type        = string
  description = "Set to true if your route53 zone is private."
}

variable "ips" {
  type = set(string)
}

variable "hostname" {
  type = string
}