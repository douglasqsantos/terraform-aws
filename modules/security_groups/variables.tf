# VPC Id
# https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-vpcs.html
# aws ec2 describe-vpcs | jq -r '.Vpcs[0].VpcId'
variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type        = string
  default     = null
}

# Security Group Name
variable "name" {
  description = "Security Group Rule Name"
  type        = string
  default     = null
}

# Security Group Description
variable "description" {
  description = "Security Group Description"
  type        = string
  default     = "Security Group managed by Terraform"
}

# Rules Ingress
variable "rules_ingress" {
  description = "Default Rules to Enable access from GitHub WebHook"
  type        = list(any)
  default = [
    {
      description = "Allowing port 80 from GitHub WebHook",
      port        = 80,
      cidr_blocks = ["192.30.252.0/22", "185.199.108.0/22", "140.82.112.0/20", "143.55.64.0/20"],
      protocol    = "tcp",
      }, {
      description = "Allowing port 443 from GitHub WebHook",
      port        = 443,
      cidr_blocks = ["192.30.252.0/22", "185.199.108.0/22", "140.82.112.0/20", "143.55.64.0/20"],
      protocol    = "tcp",
    }
  ]
}

# Rules Ingress
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group
variable "rules_egress" {
  description = "Default Rules for Outbound"
  type        = list(any)
  default = [
    {
      description = "Allow All",
      port        = 0,
      cidr_blocks = ["0.0.0.0/0"],
      protocol    = "-1",
      }
  ]
}

# It will be used to the module caller
variable "security_group_id" {
  description = "ID of existing security group whose rules we will manage"
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
