# https://registry.terraform.io/providers/hashicorp/aws/latest/docs
provider "aws" {
  # (Optional) This is the AWS region. It must be provided, but it can also be sourced
  # from the AWS_DEFAULT_REGION environment variables, or via a shared credentials file if profile is specified.
  region = var.AWS_REGION
}