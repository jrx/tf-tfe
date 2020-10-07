resource "aws_s3_bucket" "tfe_objects" {
  bucket = "${var.cluster_name}tfe"

  versioning {
    enabled = true
  }
}