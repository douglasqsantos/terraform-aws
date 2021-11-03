
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "this" {
  # (Optional, Forces new resource) Name of the security group.
  # If omitted, Terraform will assign a random, unique name.
  name        = var.name
  # (Optional, Forces new resource) Security group description.
  # Defaults to Managed by Terraform. Cannot be "". NOTE: This field maps to the AWS GroupDescription attribute,
  # for which there is no Update API. If you'd like to classify your security groups in a way that can be updated, use tags.
  description = var.description
  # (Optional, Forces new resource) VPC ID.
  vpc_id      = var.vpc_id

  # https://blog.boltops.com/2020/10/05/terraform-hcl-loops-with-dynamic-block
  dynamic "ingress" {
    for_each = var.rules_ingress
    content {
      # (Optional) Description of this ingress rule.
      description      = ingress.value.description
      # (Required) Start port (or ICMP type number if protocol is icmp or icmpv6).
      from_port        = ingress.value.port
      # (Required) End range port (or ICMP code if protocol is icmp).
      to_port          = ingress.value.port
      # (Required) Protocol. If you select a protocol of -1 (semantically equivalent to all, which is not a valid value here),
      # you must specify a from_port and to_port equal to 0. The supported values are defined in the IpProtocol argument on
      # the IpPermission API reference. This argument is normalized to a lowercase value to match the AWS API requirement when using
      # with Terraform 0.12.x and above, please make sure that the value of the protocol is specified as lowercase when
      # using with older version of Terraform to avoid an issue during upgrade.
      protocol         = ingress.value.protocol
      # (Optional) List of CIDR blocks.
      cidr_blocks      = ingress.value.cidr_blocks
      # (Optional) List of IPv6 CIDR blocks.
      ipv6_cidr_blocks = null
      # (Optional) List of Prefix List IDs.
      prefix_list_ids  = null
      # (Optional) List of security group Group Names if using EC2-Classic, or Group IDs if using a VPC.
      security_groups  = null
      # (Optional) Whether the security group itself will be added as a source to this ingress rule.
      self             = null
    }
  }

  # https://blog.boltops.com/2020/10/05/terraform-hcl-loops-with-dynamic-block
  dynamic "egress" {
    for_each = var.rules_egress
    content {
      # (Optional) Description of this ingress rule.
      description      = egress.value.description
      # (Required) Start port (or ICMP type number if protocol is icmp or icmpv6).
      from_port        = egress.value.port
      # (Required) End range port (or ICMP code if protocol is icmp).
      to_port          = egress.value.port
      # (Required) Protocol. If you select a protocol of -1 (semantically equivalent to all, which is not a valid value here),
      # you must specify a from_port and to_port equal to 0. The supported values are defined in the IpProtocol argument on
      # the IpPermission API reference. This argument is normalized to a lowercase value to match the AWS API requirement when using
      # with Terraform 0.12.x and above, please make sure that the value of the protocol is specified as lowercase when
      # using with older version of Terraform to avoid an issue during upgrade.
      protocol         = egress.value.protocol
      # (Optional) List of CIDR blocks.
      cidr_blocks      = egress.value.cidr_blocks
      # (Optional) List of IPv6 CIDR blocks.
      ipv6_cidr_blocks = null
      # (Optional) List of Prefix List IDs.
      prefix_list_ids  = null
      # (Optional) List of security group Group Names if using EC2-Classic, or Group IDs if using a VPC.
      security_groups  = null
      # (Optional) Whether the security group itself will be added as a source to this ingress rule.
      self             = null
    }
  }

  # (Optional) A map of tags to assign to the resource.
  # Note that these tags apply to the instance and not block storage devices.
  # If configured with a provider
  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
  )

  # The timeouts block allows you to specify timeouts for certain actions:
  timeouts {
    # (Default 10m) How long to wait for a security group to be created.
    create = var.create_timeout
    # (Default 15m) How long to retry on DependencyViolation errors during security group deletion
    # from lingering ENIs left by certain AWS services such as Elastic Load Balancing.
    # NOTE: Lambda ENIs can take up to 45 minutes to delete, which is not affected by
    # changing this customizable timeout (in version 2.31.0 and later of the Terraform AWS Provider)
    # unless it is increased above 45 minutes.
    delete = var.delete_timeout
  }
}


