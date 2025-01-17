terraform {}

provider "aws" {
  region = local.region
}

locals {
  db_ip   = "10.0.1.10"
  region  = var.aws_region
  name    = "${var.event_name}-osc-workshop-linux"
  my_cidr = "${chomp(data.http.my_ip.response_body)}/32"
  tags = {
    event_name = var.event_name
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.name
  cidr = "10.0.0.0/16"

  azs            = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  public_subnets = cidrsubnets("10.0.0.0/16", 8, 8)

  enable_nat_gateway = false

  manage_default_network_acl    = false
  manage_default_route_table    = false
  manage_default_security_group = false
  manage_default_vpc            = false

  tags = local.tags
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = local.name
  description = "Security group for local IP ssh"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [local.my_cidr]
  ingress_rules       = ["ssh-tcp", "all-icmp"]
  egress_rules        = ["all-all"]

  ingress_with_cidr_blocks = concat(
    [
      {
        from_port   = 2332
        to_port     = 2332
        protocol    = "tcp"
        description = "Custom SSH"
        cidr_blocks = local.my_cidr
      },
      {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        description = "Score server dashboard"
        cidr_blocks = local.my_cidr
      },
      {
        from_port   = 8000
        to_port     = 8000
        protocol    = "tcp"
        description = "Dummy web app"
        cidr_blocks = module.vpc.vpc_cidr_block
      },
      {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        description = "Score DB for team servers"
        cidr_blocks = module.vpc.vpc_cidr_block
      },
      {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        description = "Score DB for deployer"
        cidr_blocks = local.my_cidr
      }
    ],
    var.custom_security_group_ingress
  )

  tags = local.tags
}

module "db" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 4.0"

  name = "${local.name}-db"

  ami                         = data.aws_ami.latest.id
  instance_type               = "t3a.micro"
  key_name                    = aws_key_pair.main.key_name
  vpc_security_group_ids      = [module.security_group.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/usr/bin/env bash
    printf 'admin\nadmin\n' | passwd admin
    grep -q 2332 /etc/ssh/sshd_config || printf 'Port 2332\n' >> /etc/ssh/sshd_config
    systemctl restart ssh
  EOF

  tags = local.tags
}

module "team_servers" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 4.0"

  count = var.num_teams

  name = "${local.name}-team-${count.index + 1}"

  ami                         = data.aws_ami.latest.id
  instance_type               = "t3a.micro"
  key_name                    = aws_key_pair.main.key_name
  vpc_security_group_ids      = [module.security_group.security_group_id]
  subnet_id                   = module.vpc.public_subnets[count.index % 2]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/usr/bin/env bash
    printf 'admin\nadmin\n' | passwd admin
    # NOTE: setting sshd to listen on both 2332 AND regular 22
    grep -q 2332 /etc/ssh/sshd_config || printf 'Port 2332\nPort 22\n' >> /etc/ssh/sshd_config
    systemctl restart ssh
    # Variables to be sourced before init.sh runs
    printf 'export team_name="Team-${count.index + 1}"\nexport db_addr="${module.db.private_ip}"\n' > /tmp/.tfenv
  EOF

  tags = local.tags
}

resource "aws_key_pair" "main" {
  key_name   = local.name
  public_key = file(pathexpand(var.ssh_local_key_path))
}
