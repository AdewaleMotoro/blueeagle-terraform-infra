# main.tf
#
# Root module - wires together the child modules.
# Child modules are added incrementally as they're built.
#
# Currently NO child modules are called yet.
# As we build modules/s3, modules/iam, and modules/vpc, we'll add
# "module" blocks here to invoke them.
#
# Example of what a module call will look like (for reference only -
# NOT active yet because the module doesn't exist):
#
# module "s3" {
#   source       = "./modules/s3"
#   name_prefix  = local.name_prefix
#   tags         = local.common_tags
#   trainee_name = var.trainee_name
# }

module "app_s3" {
  source      = "./modules/s3"
  name_prefix = local.name_prefix
  trainee_name = var.trainee_name
  tags        = local.common_tags
}