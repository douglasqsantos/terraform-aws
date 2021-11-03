# https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-vpcs.html
# aws ec2 describe-vpcs | jq -r '.Vpcs[0].VpcId'
# (Optional, Forces new resource) VPC ID.
variable "vpc_id" {
  description = "(Optional, Forces new resource) VPC ID."
  type        = string
  default     = null
}

# (Optional, Forces new resource) Name of the security group.
# If omitted, Terraform will assign a random, unique name.
variable "name" {
  description = "(Optional, Forces new resource) Name of the security group. "
  type        = string
  default     = null
}

# (Optional, Forces new resource) Security group description.
# Defaults to Managed by Terraform. Cannot be "". NOTE: This field maps to the AWS GroupDescription attribute,
# for which there is no Update API. If you'd like to classify your security groups in a way that can be updated, use tags.
variable "description" {
  description = "(Optional, Forces new resource) Security group description."
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

# (Optional) A map of tags to assign to the resource.
# Note that these tags apply to the instance and not block storage devices.
# If configured with a provider
variable "tags" {
  description = "(Optional) A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

# (Default 10m) How long to wait for a security group to be created.
variable "create_timeout" {
  description = "How long to wait for a security group to be created."
  type        = string
  default     = "10m"
}

# (Default 15m) How long to retry on DependencyViolation errors during security group deletion
# from lingering ENIs left by certain AWS services such as Elastic Load Balancing.
# NOTE: Lambda ENIs can take up to 45 minutes to delete, which is not affected by
# changing this customizable timeout (in version 2.31.0 and later of the Terraform AWS Provider)
# unless it is increased above 45 minutes.
variable "delete_timeout" {
  description = "(Default 15m) How long to retry on DependencyViolation errors during security group deletion"
  type        = string
  default     = "20m"
}
