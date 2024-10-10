## About variable.tf file

There will be 2 separate `variables.tf` files for each module

  1. One in the module folder itself
  2. One in the root directory

The one in the root directory is just a `variables.tf` file from every module cramped into a single file

1. Root variables.tf:

- Defines variables that are used at the root level of the Terraform configuration.
- These variables can be set via command line, environment variables, or .tfvars files.
- They act as inputs for the entire Terraform configuration, including any modules you're using.

2. Module variables.tf:

- Defines the input variables specific to that module.
- These variables are set when the module is called from the root configuration.
- They define the "interface" of the module - what inputs it expects to receive.