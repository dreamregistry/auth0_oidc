
variable "app_base_url" {
  type        = string
  description = "The base url of the application"
}

variable "callback_path" {
  type        = string
  description = "Application callback path for authorization code grant"
  default     = "/auth/callback"
}

variable "logout_redirect_path" {
  type        = string
  description = "Application path to redirect to after logout"
  default     = "/auth/login"
}