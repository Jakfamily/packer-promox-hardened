packer {
  required_plugins {
    proxmox = {
      version = ">= 1.1.3"
      source  = "github.com/hashicorp/proxmox"
    }
    ansible = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

variable "iso_file" {
  type = string
}

variable "cores" {
  type    = string
  default = "4"
}

variable "disk_format" {
  type    = string
  default = "raw"
}

variable "disk_size" {
  type    = string
  default = "20G"
}

variable "disk_storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "cpu_type" {
  type    = string
  default = "kvm64"
}

variable "memory" {
  type    = string
  default = "9216"
}

variable "network_vlan" {
  type    = string
  default = ""
}

variable "machine_type" {
  type    = string
  default = ""
}

variable "proxmox_api_password" {
  type      = string
  sensitive = true
}

variable "proxmox_api_user" {
  type = string
}

variable "proxmox_host" {
  type = string
}

variable "proxmox_node" {
  type = string
}

variable "vm_id" {
  type    = number
  default = 9000
}

source "proxmox-iso" "debian" {
  proxmox_url              = "https://${var.proxmox_host}/api2/json"
  insecure_skip_tls_verify = true
  username                 = var.proxmox_api_user
  password                 = var.proxmox_api_password

  vm_id     = var.vm_id
  template_description = "Built from ${basename(var.iso_file)} on ${formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())}"
  node                 = var.proxmox_node
  network_adapters {
    bridge   = "vmbr0"
    firewall = true
    model    = "virtio"
    vlan_tag = var.network_vlan
  }
  disks {
    disk_size    = var.disk_size
    format       = var.disk_format
    io_thread    = true
    storage_pool = var.disk_storage_pool
    type         = "scsi"
  }
  scsi_controller = "virtio-scsi-single"

  http_directory = "./"
  boot_wait      = "10s"
  boot_command   = ["<esc><wait>auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed/preseed.cfg<enter>"]
  boot_iso {
    type = "scsi"
    iso_file = var.iso_file
    unmount = true
  }

  vm_name  = trimsuffix(basename(var.iso_file), ".iso")
  cpu_type = var.cpu_type
  os       = "l26"
  memory   = var.memory
  cores    = var.cores
  sockets  = "1"
  machine  = var.machine_type
  ssh_timeout = "120m"
  # Remarque : ce mot de passe est nécessaire pour que packer exécute le provisionneur de fichiers, mais
  # une fois cela fait - le mot de passe sera défini sur un mot de passe aléatoire par cloud init.
  ssh_username = "root"
  ssh_password = "packer"

}

build {
  sources = ["source.proxmox-iso.debian"]

  provisioner "ansible" {
    playbook_file = "./ansible/hardened.yml"
    extra_arguments = [
      "-vvv",
      "-e", "ansible_ssh_pipelining=True",
      "-e", "ansible_ssh_args='-o ControlMaster=auto -o ControlPersist=60s'"
    ]
  }
}
