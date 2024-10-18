
output "target_publicIP" {
  value = aws_instance.ssh_injection_target.public_ip
}

output "target_privateIP" {
  value = aws_instance.ssh_injection_target.private_ip
}

output "ssh_connect" {
  value = "boundary connect ssh -target-id=${boundary_target.ssh.id}"
}

output "ssh_connect_alias" {
  value = "boundary connect ssh ${var.scenario3_alias}"
}

output "boundary_token" {
  value     = vault_token.boundary_token.client_token
  sensitive = true
}

output "vault_ca" {
  value = chomp(vault_ssh_secret_backend_ca.boundary.public_key)
}