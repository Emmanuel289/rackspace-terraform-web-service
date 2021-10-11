
resource "aws_vpc" "prod_web" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" : "test-vpc"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.prod_web.id
  cidr_block = "10.0.1.0/24"

  tags = {
    "Name" : "subnet"
  }
}

resource "aws_subnet" "subnet2" {

  vpc_id     = aws_vpc.prod_web.id
  cidr_block = "10.0.0.0/24"

  tags = {
    "Name" : "subnet"
  }

}
