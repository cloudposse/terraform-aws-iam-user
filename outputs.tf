output "user_name" {
  description = "IAM user name"
  value       = "${element(concat(aws_iam_user.default.*.name, list("")), 0)}"
}

output "user_arn" {
  description = "The ARN assigned by AWS for this user"
  value       = "${element(concat(aws_iam_user.default.*.arn, list("")), 0)}"
}

output "user_unique_id" {
  description = "The unique ID assigned by AWS"
  value       = "${element(concat(aws_iam_user.default.*.unique_id, list("")), 0)}"
}

output "user_login_profile_key_fingerprint" {
  description = "The fingerprint of the PGP key used to encrypt the password"
  value       = "${element(concat(aws_iam_user_login_profile.default.*.key_fingerprint, list("")), 0)}"
}

output "user_login_profile_encrypted_password" {
  description = "The encrypted password, base64 encoded"
  value       = "${element(concat(aws_iam_user_login_profile.default.*.encrypted_password, list("")), 0)}"
}

output "pgp_key" {
  description = "PGP key used to encrypt sensitive data for this user"
  value       = "${var.pgp_key}"
}

# https://stackoverflow.com/questions/36565256/set-the-aws-console-password-for-iam-user-with-terraform
output "keybase_password_decrypt_command" {
  value = <<__EOF__
echo "${local.encrypted_password}" | base64 --decode | keybase pgp decrypt
__EOF__
}

output "keybase_password_pgp_message" {
  value = <<__EOF__
-----BEGIN PGP MESSAGE-----
Version: Keybase OpenPGP v2.0.76
Comment: https://keybase.io/crypto

${local.encrypted_password}
-----END PGP MESSAGE-----
__EOF__
}
