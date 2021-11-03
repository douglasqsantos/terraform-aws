# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "this" {
  # (Optional) AMI to use for the instance. Required unless launch_template is specified and the Launch Template specifes an AMI.
  # If an AMI is specified in the Launch Template, setting ami will override the AMI specified in the Launch Template.
  ami = var.ami_id
  # (Optional) The instance type to use for the instance.
  # Updates to this field will trigger a stop/start of the EC2 instance.
  instance_type = var.instance_type
  # (Optional, VPC only) A list of security group IDs to associate with.
  vpc_security_group_ids = [var.security_group_id]
  # (Optional) Key name of the Key Pair to use for the instance;
  # which can be managed using https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
  key_name = var.key_name
  # (Optional) User data to provide when launching the instance. Do not pass gzip-compressed data via this argument;
  # see user_data_base64 instead.
  user_data = var.user_data
  # (Optional) AZ to start the instance in.
  availability_zone = var.availability_zone
  # (Optional) VPC Subnet ID to launch in.
  subnet_id = var.subnet_id
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
    # (Defaults to 10 mins) Used when launching the instance (until it reaches the initial running state)
    create = var.create_timeout
    # (Defaults to 10 mins) Used when stopping and starting the instance when necessary during update - e.g. when changing instance type
    update = var.update_timeout
    # (Defaults to 20 mins) Used when terminating the instance
    delete = var.delete_timeout
  }
}

