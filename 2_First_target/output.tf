output "target_publicIP" {
  value = aws_instance.boundary_target.public_ip
}
output "ssh_connect" {
  value = "ssh -i cert.pem ubuntu@${aws_instance.boundary_target.public_ip}"
}

output "ssh_connect_alias" {
  value = "boundary connect ssh ${var.scenario1_alias}"
}

output "ssh_connect_target-id" {
  value = "boundary connect ssh -target-id ${boundary_target.aws_linux_private.id}"
}

output "ssh-key-private" {
  value = tls_private_key.rsa_4096_key.private_key_pem
}

output "ssh-key-public" {
  value = tls_private_key.rsa_4096_key.public_key_openssh
}