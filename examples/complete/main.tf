provider "aws" {
  region = var.region
}

module "user" {
  source    = "../../"
  user_name = var.user_name
  pgp_key   = "keybase:osterman"
  groups    = []

  context = module.this.context
}
