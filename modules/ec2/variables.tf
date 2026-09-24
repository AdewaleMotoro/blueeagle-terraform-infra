# modules/ec2/variables.tf
#
# Inputs for the EC2 module.

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

variable "vpc_id" {
  description = "ID of the VPC to launch the instance in."
  type        = string
}

variable "subnet_id" {
  description = "ID of the public subnet to launch the instance in."
  type        = string
}

variable "instance_profile_name" {
  description = "Name of the IAM instance profile to attach to the instance."
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair (created in AWS console)."
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the instance. Default is Ubuntu 22.04 LTS in us-east-1."
  type        = string
  default     = "ami-0c7217cdde317cfec"
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into the instance. Restrict to your IP/32 for safety."
  type        = string
}