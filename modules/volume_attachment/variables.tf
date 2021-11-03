# (Required) The device name to expose to the instance (for example, /dev/sdh or xvdh).
# See Device Naming on Linux Instances and Device Naming on Windows Instances for more information.
variable "device_name" {
  description = "(Required) The device name to expose to the instance (for example, /dev/sdh or xvdh)"
  type        = string
  default     = "/dev/xvdh"
}

# (Required) ID of the Volume to be attached
variable "volume_id" {
  description = "(Required) ID of the Volume to be attached"
  type        = string
  default     = null
}

# (Required) ID of the Instance to attach to
variable "instance_id" {
  description = "(Required) ID of the Instance to attach to"
  type        = string
  default     = null
}

# (Optional, Boolean) Set this to true if you do not wish to detach the volume from the instance to which it is attached at destroy time,
# and instead just remove the attachment from Terraform state.
# This is useful when destroying an instance which has volumes created by some other means attached.
variable "skip_destroy" {
  description = "(Optional, Boolean) Set this to true if you do not wish to detach the volume from the instance to which it is attached at destroy time and instead just remove the attachment from Terraform state"
  type        = bool
  default     = true
}
