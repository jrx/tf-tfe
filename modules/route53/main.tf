data "aws_acm_certificate" "lb" {
  domain      = var.cert_domain != "" ? var.cert_domain : "*.${var.domain}"
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "zone" {
  count        = var.update_route53 ? 1 : 0
  name         = var.domain
  private_zone = var.private_zone
}

resource "aws_route53_record" "tfe_lb" {
  count = var.update_route53 ? 1 : 0

  zone_id = data.aws_route53_zone.zone[count.index].zone_id
  name    = var.hostname
  type    = "A"
  ttl     = "10"
  records = var.ips

}