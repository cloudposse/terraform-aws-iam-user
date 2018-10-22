module "assumed_roles" {
  source    = "git::https://github.com/cloudposse/terraform-aws-iam-assumed-roles.git?ref=tags/0.2.2"
  namespace = "eg"
  stage     = "testing"
}

module "erik" {
  source = "../../"
  name   = "erik"
  pgp_key = "keybase:osterman"
  groups = ["${module.assumed_roles.group_admin_name}", "${module.assumed_roles.group_readonly_name}"]
}

module "andriy" {
  source = "../../"
  name   = "andriy"
  pgp_key = "keybase:aknysh"
  groups = ["${module.assumed_roles.group_readonly_name}"]
  enabled = "false"
}
