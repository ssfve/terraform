#resource "aws_vpc" "myapp-vpc" {
#  cidr_block = var.vpc_cidr_block
#  enable_dns_hostnames = true
#  tags = {
#    Name = "${var.env_prefix}-vpc"
#  }
#}

terraform {
  required_version = ">= 0.12.0"
  backend "s3" {
    bucket = "myapp-bucket-1989"
    key = "myapp/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr_block

  azs             = [var.avail_zone]
#  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = [var.subnet_cidr_block]

#  enable_nat_gateway = true
  enable_vpn_gateway = true
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.env_prefix}-vpc"
  }

  public_subnet_tags = {
    Name = "${var.env_prefix}-public-subnet"
  }
}

#module "myapp-subnet" {
#  source            = "./modules/subnet"
#  subnet_cidr_block = var.subnet_cidr_block
#  vpc_id            = module.vpc.vpc_id
#  avail_zone        = var.avail_zone
#  env_prefix        = var.env_prefix
#}


module "myapp-server" {
  source = "./modules/webserver"
  #   "vpc_cidr_block" {}
  #   "subnet_cidr_block" {}
  vpc_id               = module.vpc.vpc_id
  avail_zone           = var.avail_zone
  env_prefix           = var.env_prefix
  my_ip                = var.my_ip
  instance_type        = var.instance_type
  image_name           = var.image_name
  public_key_location  = var.public_key_location
  private_key_location = var.private_key_location
  subnet_id            = module.vpc.public_subnets[0]
}


