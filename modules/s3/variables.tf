# modules/s3/variables.tf
#
# Inputs the module accepts from whoever calls it.

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