resource "aws_iam_user" "default" {
  count = "${var.enabled == "true" ? 1 : 0}"

  name                 = "${var.name}"
  path                 = "${var.path}"
  permissions_boundary = "${var.permissions_boundary}"
  force_destroy        = "${var.force_destroy}"
}

resource "aws_iam_user_login_profile" "default" {
  count = "${var.enabled == "true" && var.login_profile_enabled == "true" ? 1 : 0}"

  user                    = "${aws_iam_user.default.name}"
  pgp_key                 = "${var.pgp_key}"
  password_length         = "${var.password_length}"
  password_reset_required = "${var.password_reset_required}"
}

resource "aws_iam_user_group_membership" "default" {
  count  = "${var.enabled == "true" && length(var.groups) > 0 ? 1 : 0}"
  user   = "${aws_iam_user.default.name}"
  groups = ["${var.groups}"]
}

locals {
  encrypted_password               = "${element(concat(aws_iam_user_login_profile.default.*.encrypted_password, list("")), 0)}"
  keybase_password_pgp_message     = "${data.template_file.keybase_password_pgp_message.rendered}"
  keybase_password_decrypt_command = "${data.template_file.keybase_password_decrypt_command.rendered}"
}

data "template_file" "keybase_password_decrypt_command" {
  template = "${file("${path.module}/templates/keybase_password_decrypt_command.sh")}"

  vars = {
    encrypted_password = "${local.encrypted_password}"
  }
}

data "template_file" "keybase_password_pgp_message" {
  template = "${file("${path.module}/templates/keybase_password_pgp_message.txt")}"

  vars = {
    encrypted_password = "${local.encrypted_password}"
  }
}
