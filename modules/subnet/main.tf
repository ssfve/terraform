resource "aws_route_table" "main-rtb" {
  #  route_table_id = aws_vpc.myapp-vpc.default_route_table_id
  vpc_id = var.vpc_id
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.myapp-igw.id
#      gateway_id = ""
    }
  tags = {
    Name = "${var.env_prefix}-main-rtb"
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = var.vpc_id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone

  map_public_ip_on_launch = true
  tags = {
    Name    = "${var.env_prefix}-subnet-1"
    vpn-env = "dev"
  }
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.env_prefix}-igw"
  }
}


resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.main-rtb.id
}
