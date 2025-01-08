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

output "ssh_inject_private_ip" {
  value = aws_instance.ssh_injection_target.private_ip
}

output "windows_private_ip" {
  value = aws_instance.windows-server.private_ip
}

output "aws_iam_access_key_boundary_session_recording_id" {
  value = aws_iam_access_key.boundary_session_recording.id
}

output "aws_iam_access_key_boundary_session_recording_secret" {
  value = aws_iam_access_key.boundary_session_recording.secret
  sensitive = true
}

output "aws_recording_bucket_name" {
  value = aws_s3_bucket.storage_bucket.id
}