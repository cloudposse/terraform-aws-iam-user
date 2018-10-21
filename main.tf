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
  count  = "${var.enabled == "true" ? 1 : 0}"
  user   = "${aws_iam_user.default.name}"
  groups = "${var.iam_groups}"
}

locals {
  encrypted_password = "${element(concat(aws_iam_user_login_profile.default.*.encrypted_secret, list("")), 0)}"
}
