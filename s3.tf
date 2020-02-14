resource "aws_s3_bucket" "tfe_objects" {
  bucket = "${var.cluster_name}tfe"
  region = var.aws_region
}