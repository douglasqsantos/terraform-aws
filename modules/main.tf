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
