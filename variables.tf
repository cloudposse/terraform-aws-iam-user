variable "login_profile_enabled" {
  type        = bool
  description = "Whether to create IAM user login profile"
  default     = true
}

variable "user_name" {
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
  description = "Provide a base-64 encoded PGP public key, or a keybase.io username in the form `keybase:username`. Required to encrypt password."
  default     = ""
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

variable "password_encrypted" {
  type        = bool
  description = "Sets whether the password should be given in an encrypted form or not. If encrypted then the pgp_key variable must be set."
  default     = true
}

variable "decrypted_password" {
  type        = string
  description = "Decrypted password string. Using when variable password_encrypted is set to false. If set to empty string password is create from random string. Password is only set whe user is created."
  default     = ""
}

variable "aws_cli_command" {
  description = "Command to run as AWS CLI. May include extra arguments like region and profile. Using when password_encrypted set to false"
  type        = string
  default     = "aws"
}

variable "aws_cli_profile" {
  description = "AWS profile name using durring execute cli command. Using when password_encrypted set to false"
  type        = string
  default     = ""
}

variable "bash_interpreter" {
  description = "List of interpreter arguments used to execute deploy script, first arg is path. Using when password_encrypted set to false"
  type        = list(string)
  default     = ["/bin/bash", "-c"]
}