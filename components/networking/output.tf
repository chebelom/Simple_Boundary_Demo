output "vpc_peer_id" {
  value = aws_vpc.peer.id
}

output "vpc_peer_owner_id" {
  value = aws_vpc.peer.owner_id
}

output "hvn_id" {
  value = hcp_hvn.hvn.hvn_id
}

output "private_sg" {
  value = aws_security_group.privatesg.id
}

output "private_subnet1" {
  value = aws_subnet.private1.id
}

output "public_subnet1" {
  value = aws_subnet.public1.id
}