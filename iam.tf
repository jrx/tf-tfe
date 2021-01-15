resource "aws_iam_role" "tfe_objects_role" {
  name = "tfe_objects_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "tfe_objects_profile" {
  name = "tfe_objects_profile"
  role = aws_iam_role.tfe_objects_role.name
}

resource "aws_iam_role_policy" "tfe_objects_policy" {
  role = aws_iam_role.tfe_objects_role.name
  name = "${var.cluster_name}archivist-bucket"

  policy = <<__policy
{
    "Version": "2012-10-17",
    "Statement": [{
        "Resource": [
            "arn:aws:s3:::${module.s3.bucket_id}",
            "arn:aws:s3:::${module.s3.bucket_id}/*"
        ],
        "Effect": "Allow",
        "Action": [
            "s3:*"
        ]
    }]
}
__policy
}