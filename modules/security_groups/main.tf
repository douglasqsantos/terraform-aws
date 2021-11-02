
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  # https://blog.boltops.com/2020/10/05/terraform-hcl-loops-with-dynamic-block
  dynamic "ingress" {
    for_each = var.rules_ingress
    content {
      description      = ingress.value.description
      from_port        = ingress.value.port
      to_port          = ingress.value.port
      protocol         = ingress.value.protocol
      cidr_blocks      = ingress.value.cidr_blocks
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  }

    # https://blog.boltops.com/2020/10/05/terraform-hcl-loops-with-dynamic-block
  dynamic "egress" {
    for_each = var.rules_egress
    content {
      description      = egress.value.description
      from_port        = egress.value.port
      to_port          = egress.value.port
      protocol         = egress.value.protocol
      cidr_blocks      = egress.value.cidr_blocks
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  }

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
  )

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}


