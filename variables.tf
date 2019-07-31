variable "enabled" {
  type        = bool
  description = "Whether to create the IAM user"
  default     = true
}

variable "login_profile_enabled" {
  type        = bool
  description = "Whether to create IAM user login profile"
  default     = true
}

variable "name" {
  type        = string
  description = "Desired name for the IAM user. We recommend using email addresses."
}

variable "path" {
  type        = string
  description = "Desired path for the IAM user"
  default     = "/"
}

variable "groups" {
  description = "List of IAM user groups this user should belong to in the account"
  type        = list(string)
  default     = []
}

variable "permissions_boundary" {
  type        = string
  description = "The ARN of the policy that is used to set the permissions boundary for the user"
  default     = ""
}

variable "force_destroy" {
  type        = bool
  description = "When destroying this user, destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices. Without force_destroy a user with non-Terraform-managed access keys and login profile will fail to be destroyed."
  default     = false
}

variable "pgp_key" {
  type        = string
  description = "Provide a base-64 encoded PGP public key, or a keybase username in the form `keybase:username`. Required to encrypt password."
}

variable "password_reset_required" {
  type        = bool
  description = "Whether the user should be forced to reset the generated password on first login."
  default     = true
}

variable "password_length" {
  type        = number
  description = "The length of the generated password"
  default     = 24
}
