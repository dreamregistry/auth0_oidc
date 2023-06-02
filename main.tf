terraform {
  backend "s3" {}

  required_providers {
    auth0 = {
      source  = "registry.terraform.io/auth0/auth0"
      version = "~>0.32"
    }
  }
}

provider "auth0" {
}

module "auth0_oidc" {
  source               = "github.com/hereya/terraform-modules//auth0-oidc/module?ref=v0.25.0"
  auth0_custom_domain  = var.auth0_custom_domain
  root_url             = var.root_url
  app_name_prefix      = var.app_name_prefix
  callback_path        = var.callback_path
  logout_redirect_path = var.logout_redirect_path
}

output "OIDC_CLIENT_ID" {
  value = module.auth0_oidc.OIDC_CLIENT_ID
}

output "OIDC_CLIENT_SECRET" {
  value = module.auth0_oidc.OIDC_CLIENT_SECRET
}

output "OIDC_ISSUER_URL" {
  value = module.auth0_oidc.OIDC_ISSUER_URL
}

output "OIDC_DISCOVERY_URL" {
  value = module.auth0_oidc.OIDC_DISCOVERY_URL
}

output "OIDC_LOGOUT_URL" {
  value = module.auth0_oidc.OIDC_LOGOUT_URL
}

output "OIDC_LOGOUT_REDIRECT_URL" {
  value = module.auth0_oidc.OIDC_LOGOUT_REDIRECT_URL
}

output "OIDC_CALLBACK_URL" {
  value = module.auth0_oidc.OIDC_CALLBACK_URL
}
