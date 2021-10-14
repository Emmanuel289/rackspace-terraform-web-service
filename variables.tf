# Variable definitions for resources
variable "name" {
  description = "Name of Project"
  type        = string

  default = "rackspace-assessment"

}

variable "cidr_block" {
  description = "CIDR block for VPC"
  type        = string

  default = "10.0.0.0/16"

}

variable "azs" {
  description = "Availability zones for VPC's subnets"
  type        = list(string)
  default     = ["ca-central-1a", "ca-central-1b", "ca-central-1d"]
}

variable "private_subnets" {
  description = "Private subnets within VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

}

variable "public_subnets" {
  description = "Public subnets within VPC"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24" ]

}

variable "tags" {
  description = "Tags to apply to resources within project"
  type        = map(string)
  default = {
    Rackspace   = "true"
    Environment = "dev"
    propagate_at_launch = true
  }
}

variable "metrics" {

  description = "A list of metrics to collect."
  type = list(string)
  default = [
    "GroupDesiredCapacity", "GroupInServiceCapacity", "GroupPendingCapacity",
    "GroupMinSize", "GroupMaxSize", "GroupInServiceInstances", "GroupPendingInstances",
    "GroupStandbyInstances", "GroupStandbyCapacity", "GroupTerminatingCapacity",
    "GroupTerminatingInstances", "GroupTotalCapacity", "GroupTotalInstances"
  ]

}