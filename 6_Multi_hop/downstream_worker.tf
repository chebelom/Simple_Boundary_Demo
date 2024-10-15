# Define the data source for the latest Ubuntu AMI
data "aws_ami" "ubuntu_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical account ID
}


data "aws_key_pair" "example" {
  key_name           = "ec2-key"
  include_public_key = true
}

resource "aws_instance" "boundary_downstream_worker" {
  #count                  = 1
  ami                    = data.aws_ami.ubuntu_ami.id
  instance_type          = "t2.micro"
  key_name               = data.aws_key_pair.example.key_name
  vpc_security_group_ids = [aws_security_group.publicsg.id]
  subnet_id              = aws_subnet.public1.id

  # user_data_replace_on_change = false
  user_data_base64 = data.cloudinit_config.boundary_egress_worker.rendered

  tags = {
    Name = "boundary-worker-downstream"
  }

  lifecycle {
    ignore_changes = [
      user_data_base64,
    ]
  }
}




resource "boundary_worker" "egress_pki_worker" {
  scope_id                    = "global"
  name                        = "boundary-egress-pki-worker"
  worker_generated_auth_token = ""
}

/* This locals block sets out the configuration for the Boundary Service file and 
the HCL configuration for the PKI Worker. Within the boundary_egress_worker_hcl_config
the controller_generated_activation_token pulls in the one-time token generated by the 
boundary_worker resource above.

The cloud_init config takes the content of the two configurations and specifies the path
on the EC2 instance to write to.
*/
locals {
  boundary_egress_worker_service_config = <<-WORKER_SERVICE_CONFIG
  [Unit]
  Description="HashiCorp Boundary - Identity-based access management for dynamic infrastructure"
  Documentation=https://www.boundaryproject.io/docs
  #StartLimitIntervalSec=60
  #StartLimitBurst=3

  [Service]
  ExecStart=/usr/bin/boundary server -config=/etc/boundary.d/pki-worker.hcl
  ExecReload=/bin/kill --signal HUP $MAINPID
  KillMode=process
  KillSignal=SIGINT
  Restart=on-failure
  RestartSec=5
  TimeoutStopSec=30
  LimitMEMLOCK=infinity

  [Install]
  WantedBy=multi-user.target
  WORKER_SERVICE_CONFIG

  boundary_egress_worker_hcl_config = <<-WORKER_HCL_CONFIG
  disable_mlock = true

  listener "tcp" {
    address = "0.0.0.0:9202"
    purpose = "proxy"
  }

  worker {
    public_addr = "IP" # This ip will be updated with the host public ip
    # Connecting to upstream worker created in the previous step
    initial_upstreams = ["${data.tfe_outputs.self-managed-5.values.upstreamWorker_publicFQDN}:9202"]
    auth_storage_path = "/etc/boundary.d/worker"
    controller_generated_activation_token = "${boundary_worker.egress_pki_worker.controller_generated_activation_token}"
    tags {
      type = ["worker-multi", "downstream"]
    }
  }
WORKER_HCL_CONFIG

  cloudinit_config_boundary_egress_worker = {
    write_files = [
      {
        content = local.boundary_egress_worker_service_config
        path    = "/etc/systemd/system/boundary.service"
      },

      {
        content = local.boundary_egress_worker_hcl_config
        path    = "/etc/boundary.d/pki-worker.hcl"
      },
    ]
  }
}

/* This data block pulls in all the different parts of the configuration to be deployed.
These are executed in the order that they are written. Firstly, the boundary-worker binary
will be called. Secondly, the configuration specified in the locals block will be called.
Lastly the boundary-worker process is started using the pki-worker.hcl file.
*/
data "cloudinit_config" "boundary_egress_worker" {
  gzip          = false
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
      #!/bin/bash
      curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - ;\
      sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" ;\
      sudo apt-get update && sudo apt-get install boundary-enterprise -y
      sudo mkdir /etc/boundary.d/worker

      curl 'https://api.ipify.org?format=txt' > /tmp/ip
      export IP1=$(cat /tmp/ip)
      sudo sed -ibak "s/IP/$IP1/g" /etc/boundary.d/pki-worker.hcl
  EOF
  }
  part {
    content_type = "text/cloud-config"
    content      = yamlencode(local.cloudinit_config_boundary_egress_worker)
  }
  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
    #!/bin/bash
    sudo systemctl daemon-reload
    sudo systemctl enable boundary
    sudo systemctl start boundary
    EOF
  }
}



