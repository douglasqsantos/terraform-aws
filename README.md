# Terraform - AWS

This repository is just a bunch of modules that I use to create some AWS resources

## TODO:
- [X] EC2 Instance Module
- [X] Cloud Init Module to handle Shell Scripts
- [X] Security Groups Module
- [X] SSH Key Pair Module
- [ ] Lookup Instances - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

## Example

```bash
provider "aws" {
  region = "us-east-2"
}

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

  tags = {
    Environment = "Stage"
    Department  = "Development"
  }
}

module "ssh_key_pair" {
  source          = "./ssh_key_pair"
  name            = "ec2-access-key"
  public_key_path = "~/.ssh/id_rsa.pub"
  tags = {
    Environment = "Stage"
    Department  = "Development"
  }
}

module "cloudinit_config" {
  source      = "./cloud_init"
  script_path = "./scripts/runit.sh"
}

module "ec2_instance" {
  source            = "./ec2_instance"
  name              = "jenkins-by-terraform"
  ami_id            = "ami-0b9064170e32bde34"
  instance_type     = "t2.micro"
  vpc_id            = "vpc-0ff7f80d2384b98f2"
  security_group_id = module.security_groups.security_group_id
  key_name          = module.ssh_key_pair.key_name
  user_data         = module.cloudinit_config.rendered
  tags = {
    Environment = "Stage"
    Department  = "Development"
  }
}
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