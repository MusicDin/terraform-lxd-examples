# example3

This Terraform configuration sets up an LXD environment with a configurable
number of instances. It creates a ZFS storage pool, a network, and a profile,
and then launches instances with that profile. The instances are prefixed
with a configurable name and their count can be specified.

To change name prefix or number of instances either adjust variables in `terraform.tfvars`
or provide them using `-var` flag (`terraform apply -var="instances=5"`).

