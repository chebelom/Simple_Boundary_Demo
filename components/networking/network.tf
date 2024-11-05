
# Deploy Internet Gateway
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.peer.id

  tags = {
    Name = "Stacks-igw"
  }
}

# Deploy 2 Public Subnets
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.peer.id
  cidr_block              = "172.31.10.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Stacks-1public"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.peer.id
  cidr_block              = "172.31.11.0/24"
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Stacks-2public"
  }
}

# Deploy 2 Private Subnets
resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.peer.id
  cidr_block              = "172.31.12.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = false

  tags = {
    Name = "Stacks-1private"
  }
}

resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.peer.id
  cidr_block              = "172.31.13.0/24"
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Stacks-2private"
  }
}
# Deploy Route Table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.peer.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
  tags = {
    Name = "Stacks-routetable"
  }
}

# Associate Subnets With Route Table
resource "aws_route_table_association" "route1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "route2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.rt.id
}

# resource "aws_route_table_association" "private_route1" {
#   subnet_id      = aws_subnet.private1.id
#   route_table_id = aws_route_table.rt.id
# }

# Deploy Security Groups
resource "aws_security_group" "publicsg" {
  name        = "Stacks Public SecGroup"
  description = "SSH + Boundary port"
  vpc_id      = aws_vpc.peer.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["172.25.16.0/20"]
  }

}

resource "aws_security_group" "privatesg" {
  name        = "Stacks Privatesg"
  description = "Allow traffic"
  vpc_id      = aws_vpc.peer.id

  # ingress {
  #   from_port       = 3306
  #   to_port         = 3306
  #   protocol        = "tcp"
  #   cidr_blocks     = ["10.1.0.0/16"]
  #   security_groups = [aws_security_group.publicsg.id]
  # }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #, "172.25.16.0/20"] #, aws_subnet.public1.cidr_block]
    # security_groups = [ aws_security_group.publicsg.id ]
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

# resource "aws_security_group" "allow_vault_egress_ingress" {
#   name        = "allow_vault_egress_ingress"
#   description = "Allow Vault outbound traffic and some ingress"
#   vpc_id      = aws_vpc.peer.id

#   egress {
#     from_port   = 8200
#     to_port     = 8200
#     protocol    = "tcp"
#     cidr_blocks = ["172.25.16.0/20"]
#   }
#   # Allow connection to postgres from Vault
#   ingress {
#     from_port   = 5432
#     to_port     = 5432
#     protocol    = "tcp"
#     cidr_blocks = ["172.25.16.0/20"]
#   }
#   # Allow LDAP from Vault to VPC
#   ingress {
#     from_port   = 389
#     to_port     = 389
#     protocol    = "tcp"
#     cidr_blocks = ["172.25.16.0/20"]
#   }
# }


# # data "aws_internet_gateway" "default" {
# #   filter {
# #     name   = "attachment.vpc-id"
# #     values = [aws_vpc.peer.id]
# #   }
# # }

# # Deploy 2 Public Subnets
# resource "aws_subnet" "public1" {
#   vpc_id                  = aws_vpc.peer.id
#   cidr_block              = "172.31.10.0/24"
#   availability_zone       = "${var.region}a"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "stacks-1public"
#   }
# }

# resource "aws_subnet" "public2" {
#   vpc_id                  = aws_vpc.peer.id
#   cidr_block              = "172.31.11.0/24"
#   availability_zone       = "${var.region}b"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "stacks-2public"
#   }
# }


# resource "aws_internet_gateway" "prod-igw" {
#   # vpc_id = data.terraform_remote_state.local_backend.outputs.vpc
#   vpc_id = data.tfe_outputs.platform.values.vpc
#   tags = {
#     Name = "stacks-igw"
#   }
# }

# # Deploy 2 Private Subnets
# resource "aws_subnet" "private1" {
#   vpc_id                  = aws_vpc.peer.id
#   cidr_block              = "172.31.12.0/24"
#   availability_zone       = "${var.region}a"
#   map_public_ip_on_launch = false

#   tags = {
#     Name = "stacks-1private"
#   }
# }

# resource "aws_subnet" "private2" {
#   vpc_id                  = aws_vpc.peer.id
#   cidr_block              = "172.31.13.0/24"
#   availability_zone       = "${var.region}b"
#   map_public_ip_on_launch = false

#   tags = {
#     Name = "stacks-2private"
#   }
# }
# # Deploy Route Table
# resource "aws_route_table" "rt" {
#   vpc_id = aws_vpc.peer.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = data.aws_internet_gateway.default.id
#   }

#   # Route traffic to the HVN peering connection
#   route {
#     cidr_block                = "172.25.16.0/20"
#     vpc_peering_connection_id = hcp_aws_network_peering.peer.provider_peering_id
#   }

#   tags = {
#     Name = "stacks-route-table-self-hvn"
#   }
# }

# # Associate Subnets With Route Table
# resource "aws_route_table_association" "route1" {
#   subnet_id      = aws_subnet.public1.id
#   route_table_id = aws_route_table.rt.id
# }

# resource "aws_route_table_association" "route2" {
#   subnet_id      = aws_subnet.public2.id
#   route_table_id = aws_route_table.rt.id
# }

# # Deploy Security Groups
# resource "aws_security_group" "publicsg" {
#   name        = "Stacks Upstream Worker"
#   description = "SSH + Boundary port"
#   vpc_id      = aws_vpc.peer.id

#   # To allow direct connections from clients and downstream workers
#   ingress {
#     from_port   = 9202
#     to_port     = 9202
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]

#   }
# }

# resource "aws_security_group" "privatesg" {
#   name        = "Stacks private Sec group"
#   description = "Allow traffic"
#   vpc_id      = aws_vpc.peer.id

#   ingress {
#     from_port       = 3306
#     to_port         = 3306
#     protocol        = "tcp"
#     cidr_blocks     = ["10.0.0.0/16"]
#     security_groups = [aws_security_group.publicsg.id]
#   }
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]

#   }
# }
