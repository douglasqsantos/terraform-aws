# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
resource "aws_key_pair" "this" {
  # (Optional) The name for the key pair.
  key_name   = var.name
  # (Required) The public key material.
  public_key = file(var.public_key_path)

  # (Optional) A map of tags to assign to the resource.
  # Note that these tags apply to the instance and not block storage devices.
  # If configured with a provider
  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
  )
}
