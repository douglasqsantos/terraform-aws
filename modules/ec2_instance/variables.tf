# # https://cloud-images.ubuntu.com/locator/ec2/
variable "ami_id" {
  default = "ami-0b9064170e32bde34"
}

# Security Group Name
variable "name" {
  description = "EC-2 Name"
  type        = string
  default     = null
}

variable "instance_type" {
  default = "t2.micro"
}

variable "vpc_id" {
  default = "vpc-0ff7f80d2384b98f2"
}

variable "ssh_port" {
  default = "22"
}

variable "cidr_block" {
  default = "0.0.0.0/0"
}

variable "security_group_id" {
  description = "ID of existing security group whose rules we will manage"
  type        = string
  default     = null
}

variable "key_name" {
  description = "SSH Key Name"
  type        = string
  default     = null
}

variable "user_data" {
  description = "User Data to Process"
  type        = string
  default     = null
}

# Define tags as a Map, it is suitable for this case
variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = map(string)
  default     = {}
}

# Timeout to create the resource
variable "create_timeout" {
  description = "Time to wait for a security group to be created"
  type        = string
  default     = "10m"
}

# Timeout to delete the resource
variable "delete_timeout" {
  description = "Time to wait for a security group to be deleted"
  type        = string
  default     = "15m"
}
