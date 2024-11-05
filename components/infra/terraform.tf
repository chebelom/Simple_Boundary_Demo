terraform {
  required_providers {
    time = {
      source  = "hashicorp/time"
      version = "0.12.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.5"
    }
  }
}