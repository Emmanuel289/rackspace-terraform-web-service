variable "cidr-block" {
  description = "VPC CIDR Block"
  type        = string

  default = "10.0.0.0/16"

}

variable "name" {
  description = "Name of Project"
  type        = string

  default = "rackspace"

}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)

  default = ["us-east-1a", "us-east-1b", "us-east-1c"]

}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

}

variable "ami" {
  description = "AMI used in creating EC2 instances"
  type        = string
  default     = "ami-02e136e904f3da870"



}


variable "key" {
    type        = string
    description = "ssh key."
}
