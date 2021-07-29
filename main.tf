resource "aws_iam_user" "default" {
  count = module.this.enabled ? 1 : 0

  name                 = var.user_name
  path                 = var.path
  permissions_boundary = var.permissions_boundary
  force_destroy        = var.force_destroy
  tags                 = module.this.tags
}

resource "aws_iam_user_login_profile" "default" {
  count = module.this.enabled && var.login_profile_enabled && var.password_encrypted ? 1 : 0

  user                    = aws_iam_user.default[count.index].name
  pgp_key                 = var.pgp_key
  password_length         = var.password_length
  password_reset_required = var.password_reset_required
  depends_on              = [aws_iam_user.default]
}

resource "random_password" "password" {
  count  = module.this.enabled && var.password_encrypted == false ? 1 : 0
  length = var.password_length
  special = false
}

locals {
  aws_cli_command         = length(var.aws_cli_profile) > 0 ? "${var.aws_cli_command} --profile ${var.aws_cli_profile}" : var.aws_cli_command
  user_password           = length(var.decrypted_password) > 0 ? var.decrypted_password : join("",random_password.password.*.result)
  user_password_file_path = "${path.module}/${var.user_name}_password.txt"
  password_reset_required = var.password_reset_required ? "--password-reset-required" : "--no-password-reset-required"
  set_password_script     = <<EOF
  #!/bin/bash
  ${local.aws_cli_command} iam create-login-profile --user-name ${var.user_name} --password ${local.user_password} ${local.password_reset_required}
EOF
}

resource "null_resource" "deploy" {
  count = module.this.enabled && var.password_encrypted == false ? 1 : 0

  triggers = {
    user_unique_id = join("",aws_iam_user.default.*.unique_id)
  }

  provisioner "local-exec" {
    command     = local.set_password_script
    interpreter = var.bash_interpreter
  }
}

resource "local_file" "password_file" {
  content  = local.user_password
  filename = local.user_password_file_path
}

resource "aws_iam_user_group_membership" "default" {
  count      = module.this.enabled && length(var.groups) > 0 ? 1 : 0
  user       = aws_iam_user.default[count.index].name
  groups     = var.groups
  depends_on = [aws_iam_user.default]
}

locals {
  encrypted_password               = join("", aws_iam_user_login_profile.default.*.encrypted_password)
  pgp_key_is_keybase               = length(regexall("keybase:", var.pgp_key)) > 0 ? true : false
  keybase_password_pgp_message     = join("", data.template_file.keybase_password_pgp_message.*.rendered)
  keybase_password_decrypt_command = join("", data.template_file.keybase_password_decrypt_command.*.rendered)
}

data "template_file" "keybase_password_decrypt_command" {
  count    = local.pgp_key_is_keybase ? 1 : 0
  template = file("${path.module}/templates/keybase_password_decrypt_command.sh")

  vars = {
    encrypted_password = local.encrypted_password
  }
}

data "template_file" "keybase_password_pgp_message" {
  count    = local.pgp_key_is_keybase ? 1 : 0
  template = file("${path.module}/templates/keybase_password_pgp_message.txt")

  vars = {
    encrypted_password = local.encrypted_password
  }
}
