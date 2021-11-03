# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment
resource "aws_volume_attachment" "this" {
  # (Required) The device name to expose to the instance (for example, /dev/sdh or xvdh).
  # See Device Naming on Linux Instances and Device Naming on Windows Instances for more information.
  device_name  = var.device_name
  # (Required) ID of the Volume to be attached
  volume_id    = var.volume_id
  # (Required) ID of the Instance to attach to
  instance_id  = var.instance_id
  # (Optional, Boolean) Set this to true if you do not wish to detach the volume from the instance to
  # which it is attached at destroy time, and instead just remove the attachment from Terraform state.
  # This is useful when destroying an instance which has volumes created by some other means attached
  skip_destroy = var.skip_destroy
}
