This repository contains 3 examples to demonstrate how Terraform provider for LXD can be used:
- [example1](./example1): Single instance that relies on existing `default` profile
- [example2](./example2): Single instance with dedicated storage pool and managed network.
- [example3](./example3): Custom number of instance with dedicated storage pool and managed network.

To run a specific example:
```sh
cd example<num>
terraform apply
```
