locals {
  ssh_public_key = file("~/.ssh/ter_yc.pub")

  vm_metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.ssh_public_key}"
  }
}