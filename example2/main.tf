provider "lxd" {}

resource "lxd_storage_pool" "pool" {
  name   = "tf-pool"
  driver = "zfs"
  config = {
    "zfs.pool_name" = "tf-pool"
    "source"        = "/var/snap/lxd/common/lxd/disks/tf-pool.img"
    "size"          = "5GiB"
  }
}

resource "lxd_network" "network" {
  name = "tf-network"
  config = {
    "ipv4.address" = "10.150.19.1/24"
    "ipv4.nat"     = "true"
    "ipv6.address" = "fd42:474b:622d:259d::1/64"
    "ipv6.nat"     = "true"
  }
}

resource "lxd_profile" "profile" {
  name = "tf-profile"

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
  name      = "tf-c1"
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
