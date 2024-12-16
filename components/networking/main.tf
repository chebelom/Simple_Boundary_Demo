resource "aws_vpc" "peer" {
  cidr_block = var.aws_vpc_cidr

  tags = {
    Name = "Stacks - Boundary"
  }
  # Enabling DNS name so they can be used in some configurations
  enable_dns_hostnames = true
}

data "aws_arn" "peer" {
  arn = aws_vpc.peer.arn
}


resource "hcp_hvn" "hvn" {
  hvn_id         = var.hvn_id
  cloud_provider = var.cloud_provider
  region         = var.region
}

resource "hcp_aws_network_peering" "peer" {
  hvn_id          = hcp_hvn.hvn.hvn_id
  peering_id      = var.peering_id
  peer_vpc_id     = aws_vpc.peer.id
  peer_account_id = aws_vpc.peer.owner_id
  peer_vpc_region = var.region
}

resource "hcp_hvn_route" "peer_route" {
  hvn_link         = hcp_hvn.hvn.self_link
  hvn_route_id     = var.route_id
  destination_cidr = var.aws_vpc_cidr
  target_link      = hcp_aws_network_peering.peer.self_link
}


resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = hcp_aws_network_peering.peer.provider_peering_id
  auto_accept               = true
}

resource "aws_security_group" "allow_vault_egress" {
  name        = "allow_vault_egress"
  description = "Allow Vault outbound traffic"
  vpc_id      = aws_vpc.peer.id

  egress {
    from_port        = 8200
    to_port          = 8200
    protocol         = "tcp"
    cidr_blocks      = [var.hvn_cidr_block]
  }
}