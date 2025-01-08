data "http" "ssh_ca_public_key" {
  url = "${var.vault_public_url}/v1/ssh-client-signer/public_key"

  request_headers = {
    X-Vault-Namespace = "admin"
  }
}


locals {
  cloud_config_config = <<-END
    #cloud-config
    ${jsonencode({
  write_files = [
    {
      path        = "/etc/ssh/ca-key.pub"
      permissions = "0644"
      owner       = "root:root"
      encoding    = "b64"
      content     = base64encode(chomp(data.http.ssh_ca_public_key.response_body))
    },
  ]
})}
  END
}


resource "aws_instance" "ssh_injection_target" {
  #count                  = 1
  ami                    = data.aws_ami.ubuntu_ami.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.ec2_key.key_name
  vpc_security_group_ids = [var.private_sg]
  subnet_id               = var.private_subnet1
  # subnet_id               = var.public_subnet

  user_data_replace_on_change = true
  user_data_base64            = data.cloudinit_config.ssh.rendered

  tags = {
    Name = "SSH Injection Boundary Target"
  }
}


/* Configuring postgress Database as per 
https://developer.hashicorp.com/boundary/tutorials/credential-management/hcp-vault-cred-brokering-quickstart#setup-postgresql-northwind-demo-database
*/
data "cloudinit_config" "ssh" {
  gzip          = false
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content      = local.cloud_config_config
  }
  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
      #!/bin/bash
      sudo chown 1000:1000 /etc/ssh/ca-key.pub
      sudo chmod 644 /etc/ssh/ca-key.pub
      sudo echo TrustedUserCAKeys /etc/ssh/ca-key.pub >> /etc/ssh/sshd_config
      sudo echo PermitTTY yes >> /etc/ssh/sshd_config
      sudo sed -i 's/X11Forwarding no/X11Forwarding yes/' /etc/ssh/sshd_config
      sudo echo "X11UseLocalhost no" >> /etc/ssh/sshd_config
      sudo systemctl restart sshd

      curl 'https://api.ipify.org?format=txt' > /tmp/ip
      cat /tmp/ip
  EOF
  }
}



