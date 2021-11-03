# (Required) The contents of the template, as a string using Terraform template syntax.
# Use the file function to load the template source from a separate file on disk.
variable "script_path" {
  description = "(Required) The contents of the template, as a string using Terraform template syntax."
  type = string
  default = "scripts/runit.sh"
}

# (Optional) Variables for interpolation within the template.
# Note that variables must all be primitives. Direct references to lists or maps will cause a validation error.
variable "vars" {
  description = "(Optional) Variables for interpolation within the template. "
  type        = map(string)
  default     = {}
  # default = {
  #   DEVICE = "/dev/xvdh"
  # }
}
