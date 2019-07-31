resource "aws_iam_user" "default" {
  count = var.enabled ? 1 : 0

  name                 = var.name
  path                 = var.path
  permissions_boundary = var.permissions_boundary
  force_destroy        = var.force_destroy
}

resource "aws_iam_user_login_profile" "default" {
  count = var.enabled && var.login_profile_enabled ? 1 : 0

  user                    = aws_iam_user.default[count.index].name
  pgp_key                 = var.pgp_key
  password_length         = var.password_length
  password_reset_required = var.password_reset_required
  depends_on              = ["aws_iam_user.default"]
}

resource "aws_iam_user_group_membership" "default" {
  count      = var.enabled && length(var.groups) > 0 ? 1 : 0
  user       = aws_iam_user.default[count.index].name
  groups     = var.groups
  depends_on = ["aws_iam_user.default"]
}

locals {
  encrypted_password               = element(concat(aws_iam_user_login_profile.default.*.encrypted_password, list("")), 0)
  keybase_password_pgp_message     = templatefile("${path.module}/templates/keybase_password_pgp_message.txt", { encrypted_password = local.encrypted_password })
  keybase_password_decrypt_command = templatefile("${path.module}/templates/keybase_password_decrypt_command.sh", { encrypted_password = local.encrypted_password })
}
