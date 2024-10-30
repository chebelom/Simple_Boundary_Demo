identity_token "aws" {
  audience = ["aws.workload.identity"]
}

identity_token "hcp" {
  audience = ["hcp.workload.identity"]
}

deployment "demo" {
  inputs = {
    region                  = "eu-west-1"
    # stack_id                = "demo-ade"
    aws_role_arn            = "arn:aws:iam::865398690055:role/tfc-role"
    hcp_project_id          = "217c5d98-68ae-4475-8b60-5457e2cbad29"
    hcp_sp_name             = "hcp-terraform-stacks"
    hcp_wif_name            = "hcp-terraform-stacks"
    aws_identity_token      = identity_token.aws.jwt
    hcp_identity_token      = identity_token.hcp.jwt
  }
}