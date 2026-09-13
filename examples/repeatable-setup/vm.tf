# Example only. Fictional values; adapt before use.
#
# One virtual machine described for OpenTofu, using the community
# bpg/proxmox provider. OpenTofu's job ends when the VM exists and has
# booted with a user account. Configuring the operating system inside it
# is Ansible's job (see baseline.yml).
#
# Workflow:  tofu init  ->  tofu plan  ->  read the plan  ->  tofu apply
# Keep the state file OpenTofu writes private; it records what it manages.

terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      # Add a version constraint matching the provider release you tested.
    }
  }
}

provider "proxmox" {
  endpoint = "https://pve.homelab.example:8006/"
  # Supply credentials through environment variables or a secret store,
  # never in this file. See the provider documentation for the names.
}

variable "template_vm_id" {
  description = "ID of the Debian cloud-init template to clone."
  type        = number
}

variable "ssh_public_key" {
  description = "Public key that may log in to the new VM's user account."
  type        = string
}

resource "proxmox_virtual_environment_vm" "practice" {
  name      = "practice-01"
  node_name = "pve-example"

  # Start from a prepared Debian template instead of installing from scratch.
  clone {
    vm_id = var.template_vm_id
  }

  # Lets Proxmox and OpenTofu ask the guest for its state and addresses.
  agent {
    enabled = true
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048 # MiB, enough for a practice VM running two containers
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 20 # GiB
  }

  network_device {
    bridge = "vmbr0"
  }

  # cloud-init personalizes the fresh copy on first boot.
  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = "practice"
      keys     = [var.ssh_public_key]
    }
  }
}
