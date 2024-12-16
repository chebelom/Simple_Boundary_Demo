output "ssh_key_private" {
value = tls_private_key.rsa_4096_key.private_key_pem
sensitive = true
}

output "win_password_data" {
  value = aws_instance.windows-server.password_data
  sensitive = true
}

output "postgres_private_ip" {
  value = aws_instance.postgres_target.private_ip
}
