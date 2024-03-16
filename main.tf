provider "aws" {
  region = "ap-southeast-1"

}

variable "vpc_cidr_block" {
  description= "vpc cidr block"
}
variable "cidr_blocks" {
    description = "environment used"
  type= list(object({
    value = string
    name = string
  }))
}

resource "aws_vpc" "development-vpc" {
  cidr_block = var.cidr_blocks[0].value
  tags = {
    Name= var.cidr_blocks[0].name
  }
}

variable "subnet_cidr_block" {
    description= "subnet cidr block"
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.development-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = "ap-southeast-1a"
  tags = {
    Name= "subnet-1-dev"
    vpn-env= "dev"
  }
}

data "aws_vpc" "existing_vpc" {
  default = true
}



resource "aws_subnet" "dev-subnet-2" {
  vpc_id = data.aws_vpc.existing_vpc.id
  cidr_block = "172.31.48.0/20"
  availability_zone = "ap-southeast-1a"
  tags = {
    Name= "subnet-2-default"
  }
}

output "dev-vpc-id" {
  value = aws_vpc.development-vpc.id
}
output "dev-subnet1-id" {
  value = aws_subnet.dev-subnet-1.id
}
output "dev-subnet2-id" {
  value = aws_subnet.dev-subnet-2.id
}