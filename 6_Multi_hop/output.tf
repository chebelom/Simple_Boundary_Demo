output "downstreamWorker_publicIP" {
  value = aws_instance.boundary_downstream_worker.public_ip
}

output "internal-target_privateIP" {
  value = aws_instance.internal_target-multi.private_ip
}

output "internal-windows-target_privateIP" {
  value = aws_instance.windows-server.private_ip
}

output "targetWindows_creds_decrypted" {
  value = nonsensitive(rsadecrypt(aws_instance.windows-server.password_data, data.tfe_outputs.first-target-2.values.ssh-key-private))
}

output "ssh_connect" {
  value = "boundary connect ssh -target-id ${boundary_target.ssh.id}"
}

output "ssh_connect_alias" {
  value = "boundary connect ssh ${var.scenario5_ssh_alias}"
}

output "rdp_connect" {
  value = "boundary connect rdp -target-id=${boundary_target.win.id} -exec bash -- -c \"open rdp://full%20address=s={{boundary.addr}} && sleep 6000\""
}

output "rdp_connect_alias" {
  value = "boundary connect rdp ${var.scenario5_rdp_alias} -exec bash -- -c \"open rdp://full%20address=s={{boundary.addr}} && sleep 6000\""
}