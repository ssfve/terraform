resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.myapp-vpc.id

  egress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

#  ingress {
#    protocol   = "-1"
#    rule_no    = 200
#    action     = "allow"
#    cidr_block = "0.0.0.0/0"
#    from_port = 8
#    to_port = 0
#    icmp_type  = 8
#    icmp_code  = 0
#  }
#
#  egress {
#    protocol   = "-1"
#    rule_no    = 200
#    action     = "allow"
#    cidr_block = "0.0.0.0/0"
#    icmp_type = 8
#    icmp_code  = 0
#    from_port  = 0
#    to_port    = 0
#  }

  tags = {
    Name = "main"
  }
}

module "myapp-subnet" {
  source            = "./modules/subnet"
  subnet_cidr_block = var.subnet_cidr_block
  vpc_id            = aws_vpc.myapp-vpc.id
  avail_zone        = var.avail_zone
  env_prefix        = var.env_prefix
}


module "myapp-server" {
  source = "./modules/webserver"
  #   "vpc_cidr_block" {}
  #   "subnet_cidr_block" {}
  vpc_id               = aws_vpc.myapp-vpc.id
  avail_zone           = var.avail_zone
  env_prefix           = var.env_prefix
  my_ip                = var.my_ip
  instance_type        = var.instance_type
  image_name           = var.image_name
  public_key_location  = var.public_key_location
  private_key_location = var.private_key_location
  subnet_id            = module.myapp-subnet.subnet.id
}


