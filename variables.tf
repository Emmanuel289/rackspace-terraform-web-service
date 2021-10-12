variable "cidr-block" {

    type = string
    description = "VPC CIDR Block"
    default = "10.0.0.0/16"

}

variable "name" {
    type = string
    description = "Name of Project"
    default= "rackspace"

}

variable "availability_zones" {

    type = list(string)
    description = "List of availability zones"
    default = ["us-east-1a", "us-east-1b", "us-east-1c"]

}

variable "private_subnets" {
    description = "A list of private subnets inside the VPC"
    type        = list(string)
    default     =  ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

}

variable "public_subnets" {
    description = "A list of public subnets inside the VPC"
    type        = list(string)
    default     =  ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

}