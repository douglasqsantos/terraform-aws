# SSH Key Name
variable "name" {
  description = "Security Group Rule Name"
  type        = string
  default     = "ec2-access-key"
}

variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
  type = string
}

# Define tags as a Map, it is suitable for this case
variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = map(string)
  default     = {}
}
