resource "aws_vpc" "peer" {
  cidr_block = var.aws_vpc_cidr

  tags = {
    Name = "Boundary"
  }
  # Enabling DNS name so they can be used in some configurations
  enable_dns_hostnames = true
}

data "aws_arn" "peer" {
  arn = aws_vpc.peer.arn
}

resource "aws_security_group" "allow_vault_egress_ingress" {
  name        = "allow_vault_egress_ingress"
  description = "Allow Vault outbound traffic and some ingress"
  vpc_id      = aws_vpc.peer.id

  egress {
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = ["172.25.16.0/20"]
  }
  # Allow connection to postgres from Vault
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["172.25.16.0/20"]
  }
  # Allow LDAP from Vault to VPC
  ingress {
    from_port   = 389
    to_port     = 389
    protocol    = "tcp"
    cidr_blocks = ["172.25.16.0/20"]
  }
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = hcp_aws_network_peering.peer.provider_peering_id
  auto_accept               = true
}
