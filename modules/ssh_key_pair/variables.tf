# (Optional) The name for the key pair.
variable "name" {
  description = "(Optional) The name for the key pair."
  type        = string
  default     = "ec2-access-key"
}

# (Required) The public key material.
variable "public_key_path" {
  description = "(Required) The public key material."
  type = string
  default = "~/.ssh/id_rsa.pub"
}

# (Optional) A map of tags to assign to the resource.
# Note that these tags apply to the instance and not block storage devices.
# If configured with a provider
variable "tags" {
  description = "(Optional) A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
