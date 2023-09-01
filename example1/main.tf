provider "lxd" {}

resource "lxd_instance" "instance" {
  name      = "tf-c1"
  image     = "images:alpine/3.16"
  ephemeral = false

  profiles = [
    "default"
  ]

  config = {
    "boot.autostart" = true
  }

  limits = {
    cpu = 3
  }
}


