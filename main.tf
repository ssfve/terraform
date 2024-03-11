provider "aws" {
  region = "ap-southeast-1"
  access_key = "AKIAXHB3ZVJ5NC5W4OTO"
  secret_key = "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"
}


resource "aws_vpc" "development-vpc" {
  cidr_block = "10.0.0.0/16"

}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.development-vpc.id
  cidr_block = "10.0.10.0/24"
  availability_zone = "ap-southeast-1a"
}