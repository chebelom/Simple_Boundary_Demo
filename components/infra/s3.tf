locals {
  # hashicorp_email = split(":", data.aws_caller_identity.current.user_id)[1]
  # my_email = split("/", data.aws_caller_identity.current.arn)[2]
  hashicorp_email = "andrea.detassis@hashicorp.com"
  my_email = "this_is_a_test@hashicorp.com"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy" "demo_user_permissions_boundary" {
  name = "DemoUser"
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.storage_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "random_id" "bucket_name" {
  prefix      = "stacks-boundary-recordings"
  byte_length = 4
}

resource "aws_s3_bucket" "storage_bucket" {
  bucket        = "stacks-boundary-recordings225952952"
  force_destroy = true

  tags = {
    Name        = "stacks-demo-bucket-${local.hashicorp_email}"
    Environment = "Demo-Boundary"
    User        = "${local.hashicorp_email}"
    Stacks     = "True"
  }
}

# Create the user to be used in Boundary for session recording. Then attach the policy to the user.
resource "aws_iam_user" "boundary_session_recording" {
  name                 = "demo-${local.my_email}-bsr"
  permissions_boundary = data.aws_iam_policy.demo_user_permissions_boundary.arn
  force_destroy        = true
  tags                 = var.common_tags
}

resource "aws_iam_user_policy_attachment" "boundary_session_recording" {
  user       = aws_iam_user.boundary_session_recording.name
  policy_arn = data.aws_iam_policy.demo_user_permissions_boundary.arn
}

data "aws_iam_policy_document" "boundary_user_policy" {
  statement {
    sid = "InteractWithS3"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectAttributes",
    ]
    resources = ["arn:aws:s3:::${aws_s3_bucket.storage_bucket.arn}/*"]
  }
  statement {
    actions = [
      "iam:DeleteAccessKey",
      "iam:GetUser",
      "iam:CreateAccessKey"
    ]
    resources = [aws_iam_user.boundary_session_recording.arn]
  }
}

resource "aws_iam_policy" "boundary_user_policy" {
  name        = "demo-${local.my_email}-bsr-policy"
  path        = "/"
  description = "Managed policy for the Boundary user recorder"
  policy      = data.aws_iam_policy_document.boundary_user_policy.json
  tags        = var.common_tags
}


resource "aws_iam_user_policy_attachment" "boundary_user_policy" {
  user       = aws_iam_user.boundary_session_recording.name
  policy_arn = aws_iam_policy.boundary_user_policy.arn
}

# Generate some secrets to pass in to the Boundary configuration.
# WARNING: These secrets are not encrypted in the state file. Ensure that you do not commit your state file!
resource "aws_iam_access_key" "boundary_session_recording" {
  user       = aws_iam_user.boundary_session_recording.name
  depends_on = [aws_iam_user_policy_attachment.boundary_session_recording]
}

# AWS is eventually-consistent when creating IAM Users. Introduce a wait
# before handing credentails off to boundary.
resource "time_sleep" "boundary_session_recording_user_ready" {
  create_duration = "10s"

  depends_on = [aws_iam_access_key.boundary_session_recording]
}