# Registry module which creates VPC resources on AWS
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "${var.name}-vpc"
  cidr                 = var.cidr_block
  azs                  = var.azs
  private_subnets      = var.private_subnets
  public_subnets       = var.public_subnets
  enable_dns_hostnames = true
  tags                 = var.tags
}













