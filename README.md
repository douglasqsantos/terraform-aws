# Terraform - AWS

This repository is just a bunch of modules that I use to create some AWS resources

## TODO

- [X] EC2 Instance Module
- [X] Cloud Init Module to handle Shell Scripts
- [X] Security Groups Module
- [X] SSH Key Pair Module
- [X] AMI Search Module
- [X] EBS Volume Module
- [X] Volume Attachment Module

## Example

**main.tf** file below.

```bash
# A local value assigns a name to an expression, allowing it to be used multiple times within a module without repeating it.
# https://www.terraform.io/docs/configuration/locals.html
locals {
  availability_zone = format("%sa", var.AWS_REGION) # Concat AWS_REGION with letter 'a' so we have: us-east-2a
  tags = {
    Environment = "Stage"
    Department  = "Development"
  }
}

## Search Ubuntu Focal AMI
# Will get all the information for a given ami: aws ec2 describe-images --image-ids ami-0629230e074c580f2
module "ubuntu_focal" {
  source                        = "./ami_search"
  filter_by_name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
  filter_by_virtualization_type = "hvm"
  filter_by_root_device_type    = "ebs"
  filter_by_architecture        = "x86_64"
  filter_by_owners              = "099720109477"
}

# output "ubuntu_focal_ami_module" {
#   value = module.ubuntu_focal.ami_id
# }

# ## Search Debian Buster AMI
# # Will get all the information for a given ami: aws ec2 describe-images --image-ids ami-0d90bed76900e679a
# module "debian_buster" {
#   source                        = "./ami_search"
#   filter_by_name                = "debian-10-amd64-*"
#   filter_by_virtualization_type = "hvm"
#   filter_by_root_device_type    = "ebs"
#   filter_by_architecture        = "x86_64"
#   filter_by_owners              = "136693071363"
# }

# output "debian_buster_ami_module" {
#   value = module.debian_buster.ami_id
# }

# ## Search Amazon Linux 2  AMI
# # Will get all the information for a given ami: aws ec2 describe-images --image-ids ami-0f19d220602031aed
# module "amazon_linux_2" {
#   source                        = "./ami_search"
#   filter_by_name                = "amzn2-ami-hvm-*-x86_64-gp2"
#   filter_by_virtualization_type = "hvm"
#   filter_by_root_device_type    = "ebs"
#   filter_by_architecture        = "x86_64"
#   filter_by_owners              = "137112412989"
# }

# output "amazon_linux_2_ami_module" {
#   value = module.amazon_linux_2.ami_id
# }

# Security Groups Module to Handle GitHub WebHook access
module "security_groups" {
  source      = "./security_groups"
  name        = "Allow-Access-from-GitHub-WebHook"
  description = "Allow Access from GitHub WebHook"
  rules_ingress = [
    {
      description = "Allowing port 80 from GitHub WebHook",
      port        = 80,
      # https://api.github.com/meta
      cidr_blocks = ["192.30.252.0/22", "185.199.108.0/22", "140.82.112.0/20", "143.55.64.0/20"],
      protocol    = "tcp",
      }, {
      description = "Allowing port 443 from GitHub WebHook",
      port        = 443,
      # https://api.github.com/meta
      cidr_blocks = ["192.30.252.0/22", "185.199.108.0/22", "140.82.112.0/20", "143.55.64.0/20"],
      protocol    = "tcp",
      }, {
      description = "Allowing SSH Access",
      port        = 22,
      cidr_blocks = ["138.94.170.162/32"],
      protocol    = "tcp",
      }, {
      description = "Allowing HTTP Access",
      port        = 80,
      cidr_blocks = ["138.94.170.162/32"],
      protocol    = "tcp",
    }
  ]

  rules_egress = [
    {
      description = "Allow All",
      port        = 0,
      cidr_blocks = ["0.0.0.0/0"],
      protocol    = "-1",
    }
  ]
  # Tags
  tags = local.tags
}

# SSH Key Pair module to handle SSH Key Pair
module "ssh_key_pair" {
  source          = "./ssh_key_pair"
  name            = "ec2-access-key"
  public_key_path = "~/.ssh/id_rsa.pub"
  # Tags
  tags = local.tags
}

# Cloud Init Module to handle user_data scripts
module "cloudinit_config" {
  source      = "./cloud_init"
  script_path = "./scripts/runit.sh"
}

# EC2 Instance Module to Handle Instances
module "ec2_instance" {
  source            = "./ec2_instance"
  name              = "jenkins-by-terraform"
  ami_id            = module.ubuntu_focal.ami_id
  instance_type     = "t2.micro"
  availability_zone = local.availability_zone # If you are using an ebs_volume both should be on the same AZ
  security_group_id = module.security_groups.security_group_id
  key_name          = module.ssh_key_pair.key_name
  user_data         = module.cloudinit_config.rendered
  # Tags
  tags = local.tags
}

# EBS Volume Module to Handle Volumes
module "ebs_volume" {
  source            = "./ebs_volume"
  name              = "User Data"
  availability_zone = local.availability_zone
  size              = 5
  type              = "gp2"
  encrypted         = false
  # Tags
  tags = local.tags
}

# Volume Attachment Module to handle Volume attachments
module "volume_attachment" {
  source       = "./volume_attachment"
  device_name  = "/dev/xvdh"
  volume_id    = module.ebs_volume.ebs_volume_id
  instance_id  = module.ec2_instance.ec2_instance_id
  skip_destroy = true # skip destroy to avoid issues with terraform destroy
}
```

**output.tf** file below

```bash
# The public IP address assigned to the instance, if applicable.
# NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly
# and not use public_ip as this field will change after the EIP is attached.
output "public_ip" {
  value = module.ec2_instance.public_ip
}
```

**provider.tf** file below

```bash
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs
provider "aws" {
  # (Optional) This is the AWS region. It must be provided, but it can also be sourced
  # from the AWS_DEFAULT_REGION environment variables, or via a shared credentials file if profile is specified.
  region = var.AWS_REGION
}
```

**variables.tf** file below

```bash
# (Optional) This is the AWS region. It must be provided, but it can also be sourced
# from the AWS_DEFAULT_REGION environment variables, or via a shared credentials file if profile is specified.
variable "AWS_REGION" {
  default = "us-east-2"
}
```

Executing

```bash
terraform init
terraform plan -out file.out
terraform apply file.out
terraform destroy -auto-approve
```


## AWSCLI

- https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-mac.html

## Creating AWS terraform user

- IAM
- User
  - Add User
  - User name: terraform
    - Access key - Programmatic access
  - create a group
    - group name: terraform-administrators
  - policy name: administratorAccess
  - Tag:
    - Name: terraform
    - Create User:

## AWSCLI Version

- https://docs.aws.amazon.com/cli/latest/reference/iam

```bash
# List all the groups
aws iam list-groups
# Create the terraform Group
aws iam create-group --group-name terraform-administrators
{
    "Group": {
        "Path": "/",
        "GroupName": "terraform-administrators",
        "GroupId": "xxxx",
        "Arn": "arn:aws:iam::00000:group/terraform-administrators",
        "CreateDate": "2021-11-01T21:09:53+00:00"
    }
}
# Now needs to add the administrator access to the group
aws iam attach-group-policy --group-name terraform-administrators --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
# List the attached policies
aws iam list-attached-group-policies --group-name terraform-administrators
# Creating the user
aws iam create-user --user-name terraform
{
    "User": {
        "Path": "/",
        "UserName": "terraform",
        "UserId": "xxx",
        "Arn": "arn:aws:iam::000:user/terraform",
        "CreateDate": "2021-11-01T21:16:59+00:00"
    }
}
# Creating the access key
aws iam create-access-key --user-name terraform
{
    "AccessKey": {
        "UserName": "terraform",
        "AccessKeyId": "xxx",
        "Status": "Active",
        "SecretAccessKey": "xxxx",
        "CreateDate": "2021-11-01T21:17:30+00:00"
    }
}
## adding the user to the group
aws iam add-user-to-group --user-name terraform --group-name terraform-administrators
# List the users
aws iam list-users
```


## Configuring as environment variables

```bash
export AWS_ACCESS_KEY_ID="xxx"
export AWS_SECRET_ACCESS_KEY="xxx"
export AWS_DEFAULT_REGION="us-east-2"
```

## Useful Commands

```bash
$ terraform plan                         # plan
$ terraform apply                        # shortcut for plan & apply - avoid this in production
$ terraform plan -out out.terraform      # terraform plan and write the plan to out file
$ terraform apply out.terraform          # apply terraform plan using out file
$ terraform show                         # show current state
$ cat terraform.tfstate                  # show state in JSON format

$ terraform init
$ terraform validate
$ terraform plan
$ terraform apply -auto-approve
$ terraform destroy -auto-approve
```

## Using the console

```bash
cd terraform-test
terraform console
> var.myvar
"hello terraform"
> var.mymap["mykey"]
"my value"
> var.mylist
tolist([
  1,
  2,
  3,
])
> var.mylist[0]
1
> element(var.mylist,0)
1
> slice(var.mylist,0,2)
tolist([
  1,
  2,
])
```

## List instances

- https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-instances.html


## Reference Documentation

- Download URL: https://www.terraform.io/downloads.html
- AWS Resources: https://www.terraform.io/docs/providers/aws/
- List of providers: https://www.terraform.io/docs/providers/index.html
- List of AMIs for ubuntu: https://cloud-images.ubuntu.com/locator/ec2/ (hint: make sure not to pick arm64 if you're on amd64)
- Lambda github ip security group: https://github.com/sys0dm1n/lambda-github-ip-security-group-update
- GitHub WebHook ips: https://api.github.com/meta
- Dynamic block: https://blog.boltops.com/2020/10/05/terraform-hcl-loops-with-dynamic-block
- Foreach: https://blog.boltops.com/2020/10/04/terraform-hcl-loops-with-count-and-for-each
- Conditional: https://blog.boltops.com/2020/10/03/terraform-hcl-conditional-logic
