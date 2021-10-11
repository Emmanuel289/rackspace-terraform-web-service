
# # Define VPC configuration
# resource "aws_vpc" "prod_web" {
#   cidr_block = "10.0.0.0/16"

#   tags = {
#     "Name" : "rackspace-vpc"
#   }
# }


# # Define configuration for public subnet
# resource "aws_subnet" "az1" {
#   vpc_id            = aws_vpc.prod_web.id
#   cidr_block        = "10.0.0.0/24"
#   availability_zone = "ca-central-1a"

#   tags = {
#     "Name" : "rackspace-public"
#   }
# }

# # Define configuration for private subnet
# resource "aws_subnet" "az2" {

#   vpc_id            = aws_vpc.prod_web.id
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = "ca-central-1b"

#   tags = {
#     "Name" : "rackspace-private"
#   }

# }


# Terraform module which creates VPC resources on AWS => https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "rackspace-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ca-central-1a", "ca-central-1b", "ca-central-1d"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Rackspace = "true"
    Environment = "dev"
  }
}

