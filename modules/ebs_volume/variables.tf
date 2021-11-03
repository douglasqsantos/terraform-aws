# EBS Volume Name (as Tag Name)
variable "name" {
  description = "EBS Name"
  type        = string
  default     = "EBS Volume"
}

# (Required) The AZ where the EBS volume will exist.
variable "availability_zone" {
  description = "(Required) The AZ where the EBS volume will exist"
  type        = string
  default     = "us-east-2a"
}

# (Optional) The type of EBS volume. Can be standard, gp2, gp3, io1, io2, sc1 or st1 (Default: gp2).
variable "type" {
  description = "(Optional) The type of EBS volume. Can be standard, gp2, gp3, io1, io2, sc1 or st1 (Default: gp2)"
  type        = string
  default     = "gp2"
}

# (Optional) The size of the drive in GiBs.
variable "size" {
  description = "(Optional) The size of the drive in GiBs."
  type        = number
  default     = 5
}

# (Optional) If true, the disk will be encrypted.
variable "encrypted" {
  description = "(Optional) If true, the disk will be encrypted."
  type        = bool
  default     = false
}

# (Optional) A map of tags to assign to the resource.
# If configured with a provider default_tags configuration block present,
# tags with matching keys will overwrite those defined at the provider-level.
variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = map(string)
  default     = {}
}
