# (Optional) AMI to use for the instance. Required unless launch_template is specified and the Launch Template specifes an AMI.
# If an AMI is specified in the Launch Template, setting ami will override the AMI specified in the Launch Template.
variable "ami_id" {
  description = "Required unless launch_template is specified and the Launch Template specifes an AMI."
  type        = string
  default     = "ami-0b9064170e32bde34"
}

# Instance Name it will be placed as tag Name
variable "name" {
  description = "Instance Name it will be places into the tags as Name"
  type        = string
  default     = null
}

# (Optional) The instance type to use for the instance.
# Updates to this field will trigger a stop/start of the EC2 instance.
variable "instance_type" {
  description = "The instance type to use for the instance."
  default     = "t2.micro"
  type        = string
}

# (Optional) AZ to start the instance in.
variable "availability_zone" {
  description = "(Optional) AZ to start the instance in."
  type        = string
  default     = null
}

# (Optional) VPC Subnet ID to launch in.
variable "subnet_id" {
  description = "(Optional) VPC Subnet ID to launch in."
  type        = string
  default     = null
}

# (Optional, VPC only) A list of security group IDs to associate with.
variable "security_group_id" {
  description = "(Optional, VPC only) A list of security group IDs to associate with."
  type        = string
  default     = null
}

# (Optional) Key name of the Key Pair to use for the instance;
# which can be managed using https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
variable "key_name" {
  description = "Key name of the Key Pair to use for the instance"
  type        = string
  default     = null
}

# (Optional) User data to provide when launching the instance. Do not pass gzip-compressed data via this argument;
# see user_data_base64 instead.
variable "user_data" {
  description = "User data to provide when launching the instance"
  type        = string
  default     = null
}

# (Optional) A map of tags to assign to the resource.
# Note that these tags apply to the instance and not block storage devices.
# If configured with a provider
variable "tags" {
  description = "(Optional) A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

# (Defaults to 10 mins) Used when launching the instance (until it reaches the initial running state)
variable "create_timeout" {
  description = "Used when launching the instance (until it reaches the initial running state)"
  type        = string
  default     = "10m"
}

# (Defaults to 10 mins) Used when stopping and starting the instance when necessary during update - e.g. when changing instance type
variable "update_timeout" {
  description = "Used when stopping and starting the instance when necessary during update"
  type        = string
  default     = "10m"
}

# (Defaults to 20 mins) Used when terminating the instance
variable "delete_timeout" {
  description = "Used when terminating the instance"
  type        = string
  default     = "20m"
}
