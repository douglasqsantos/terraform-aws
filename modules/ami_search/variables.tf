# The name of the AMI that was provided during image creation.
variable "filter_by_name" {
  description = "The name of the AMI that was provided during image creation."
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
}

# The type of virtualization of the AMI (ie: hvm or paravirtual).
variable "filter_by_virtualization_type" {
  description = "The type of virtualization of the AMI (ie: hvm or paravirtual)."
  type        = string
  default     = "hvm"
}

# The type of root device (ie: ebs or instance-store).
variable "filter_by_root_device_type" {
  description = "The type of root device (ie: ebs or instance-store)."
  type        = string
  default     = "ebs"
}

# The OS architecture of the AMI (ie: i386 or x86_64).
variable "filter_by_architecture" {
  description = "The OS architecture of the AMI (ie: i386 or x86_64)."
  type        = string
  default     = "x86_64"
}

# The OS architecture of the AMI (ie: i386 or x86_64).
# Canonical - 099720109477
# Amazon - 137112412989
# Debian - 136693071363
variable "filter_by_owners" {
  description = "The AWS account ID of the image owner."
  type        = string
  default     = "099720109477" # Canonical
}
