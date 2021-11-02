# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
resource "aws_key_pair" "this" {
  key_name   = var.name
  public_key = file(var.public_key_path)

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
  )
}
