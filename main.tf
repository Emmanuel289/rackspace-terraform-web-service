
# Define VPC configuration
resource "aws_vpc" "prod_web" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" : "rackspace-vpc"
  }
}

# Define configuration for public subnet
resource "aws_subnet" "az1" {
  vpc_id            = aws_vpc.prod_web.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ca-central-1a"

  tags = {
    "Name" : "rackspace-public"
  }
}

# Define configuration for private subnet
resource "aws_subnet" "az2" {

  vpc_id            = aws_vpc.prod_web.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ca-central-1b"

  tags = {
    "Name" : "rackspace-private"
  }

}
