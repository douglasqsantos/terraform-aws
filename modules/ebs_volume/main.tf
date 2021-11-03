# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume
resource "aws_ebs_volume" "this" {
  # (Required) The AZ where the EBS volume will exist.
  availability_zone = var.availability_zone
  # (Optional) The size of the drive in GiBs.
  size = var.size
  # (Optional) The type of EBS volume. Can be standard, gp2, gp3, io1, io2, sc1 or st1 (Default: gp2).
  type = var.type
  # (Optional) If true, the disk will be encrypted.
  encrypted = var.encrypted
  # (Optional) A map of tags to assign to the resource.
  # If configured with a provider default_tags configuration block present,
  # tags with matching keys will overwrite those defined at the provider-level.
  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
  )
}
