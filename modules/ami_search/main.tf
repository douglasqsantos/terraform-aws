# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html
# aws ec2 describe-images --image-ids ami-00399ec92321828f5
data "aws_ami" "this" {
  # (Optional) If more than one result is returned, use the most recent AMI.
  most_recent = true

  # (Optional) One or more name/value pairs to filter off of. There are several valid keys, for a full reference
  # Check out http://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html
  filter {
    name   = "name"
    values = [var.filter_by_name]
  }

  # (Optional) One or more name/value pairs to filter off of. There are several valid keys, for a full reference
  # Check out http://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html
  filter {
    name   = "virtualization-type"
    values = [var.filter_by_virtualization_type]
  }

  # (Optional) One or more name/value pairs to filter off of. There are several valid keys, for a full reference
  # Check out http://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html
  filter {
    name   = "root-device-type"
    values = [var.filter_by_root_device_type]
  }

  # (Optional) One or more name/value pairs to filter off of. There are several valid keys, for a full reference
  # Check out http://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html
  filter {
    name   = "architecture"
    values = [var.filter_by_architecture]
  }

  # (Required) List of AMI owners to limit search. At least 1 value must be specified.
  # Valid values: an AWS account ID, self (the current account), or
  # an AWS owner alias (e.g. amazon, aws-marketplace, microsoft).
  owners = [var.filter_by_owners]
}
