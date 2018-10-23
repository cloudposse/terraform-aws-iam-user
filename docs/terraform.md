
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| enabled | Whether to create the IAM user | string | `true` | no |
| force_destroy | When destroying this user, destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices. Without force_destroy a user with non-Terraform-managed access keys and login profile will fail to be destroyed. | string | `false` | no |
| groups | List of IAM user groups this user should belong to in the account | list | `<list>` | no |
| login_profile_enabled | Whether to create IAM user login profile | string | `true` | no |
| name | Desired name for the IAM user. We recommend using email addresses. | string | - | yes |
| password_length | The length of the generated password | string | `24` | no |
| password_reset_required | Whether the user should be forced to reset the generated password on first login. | string | `true` | no |
| path | Desired path for the IAM user | string | `/` | no |
| permissions_boundary | The ARN of the policy that is used to set the permissions boundary for the user | string | `` | no |
| pgp_key | Provide a base-64 encoded PGP public key, or a keybase username in the form `keybase:username`. Required to encrypt password. | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| keybase_password_decrypt_command | Command to decrypt the Keybase encrypted password |
| keybase_password_pgp_message | PGP encrypted message (e.g. suitable for email exchanges) |
| pgp_key | PGP key used to encrypt sensitive data for this user |
| user_arn | The ARN assigned by AWS for this user |
| user_login_profile_encrypted_password | The encrypted password, base64 encoded |
| user_login_profile_key_fingerprint | The fingerprint of the PGP key used to encrypt the password |
| user_name | IAM user name |
| user_unique_id | The unique ID assigned by AWS |

