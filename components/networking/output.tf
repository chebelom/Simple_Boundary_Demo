output "vpc_peer_id" {
  value = aws_vpc.peer.id
}

output "vpc_peer_owner_id" {
  value = aws_vpc.peer.owner_id
}
