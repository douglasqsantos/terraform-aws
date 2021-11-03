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
