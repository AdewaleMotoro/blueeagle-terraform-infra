# modules/vpc/variables.tf
#
# Inputs the VPC module accepts from whoever calls it.

variable "name_prefix" {
  description = "Prefix used for naming resources (e.g., 'blueeagle-dev')."
  type        = string
}

variable "trainee_name" {
  description = "Owner name, used for tagging."
  type        = string
}

variable "tags" {
  description = "Map of tags to apply to all resources in this module."
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC (e.g., '10.0.0.0/16')."
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "Number of Availability Zones to spread subnets across."
  type        = number
  default     = 2
}
