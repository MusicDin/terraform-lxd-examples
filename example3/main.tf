provider "lxd" {}

#
# Input variables
#

variable "name_prefix" {
  description = "Resource name prefix."
  type        = string
  default     = "tf"
}

variable "instances" {
  description = "Number of instances (default: 1)"
  type        = number
  default     = 1
}

#
# Output
#

output "instances" {
  value = {
    for instance in lxd_instance.instance :
    instance.name => {
      ipv4_address = instance.ipv4_address
      ipv6_address = instance.ipv6_address
      status       = instance.status
    }
  }
}

#
# Resources
#

resource "lxd_storage_pool" "pool" {
  name   = "${var.name_prefix}-pool"
  driver = "zfs"
  config = {
    "zfs.pool_name" = "${var.name_prefix}-pool"
    "source"        = "/var/snap/lxd/common/lxd/disks/${var.name_prefix}-pool.img"
    "size"          = "5GiB"
  }
}

resource "lxd_network" "network" {
  name = "${var.name_prefix}-net"
  config = {
    "ipv4.address" = "10.150.19.1/24"
    "ipv4.nat"     = "true"
    "ipv6.address" = "fd42:474b:622d:259d::1/64"
    "ipv6.nat"     = "true"
  }
}

resource "lxd_profile" "profile" {
  name = "${var.name_prefix}-profile"

  device {
    type = "disk"
    name = "root"
    properties = {
      pool = lxd_storage_pool.pool.name
      path = "/"
    }
  }

  device {
    name = "eth0"
    type = "nic"
    properties = {
      nictype = "bridged"
      parent  = lxd_network.network.name
    }
  }
}

resource "lxd_instance" "instance" {
  count = var.instances

  name      = "${var.name_prefix}-c${count.index}"
  image     = "images:alpine/3.16"
  ephemeral = false
  profiles  = [lxd_profile.profile.name]

  config = {
    "boot.autostart" = true
  }

  limits = {
    cpu = 2
  }
}
