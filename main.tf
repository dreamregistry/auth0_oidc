terraform {
  backend "s3" {}

  required_providers {
    random = {
      source  = "registry.terraform.io/hashicorp/random"
      version = "3.2.0"
    }

    auth0 = {
      source  = "registry.terraform.io/auth0/auth0"
      version = "0.32.0"
    }
  }
}

provider "random" {}
provider "auth0" {
  audience = var.auth0_audience
}

data "aws_region" "current" {}
data "auth0_tenant" "current" {}

resource "random_pet" "client_name" {}

resource "auth0_client" "client" {
  name                = random_pet.client_name.id
  description         = "OIDC Client suitable for full-stack web applications"
  app_type            = "regular_web"
  is_first_party      = true
  callbacks           = ["${var.root_url}${var.callback_path}"]
  allowed_logout_urls = [var.root_url, "${var.root_url}${var.logout_redirect_path}"]
  jwt_configuration {
    alg = "RS256"
  }
}

resource "aws_ssm_parameter" "client_secret" {
  name        = "/auth0_oidc/${auth0_client.client.name}/client-secret"
  description = "The auth0 client secret"
  type        = "SecureString"
  value       = auth0_client.client.client_secret
}

output "OIDC_CLIENT_ID" {
  value     = auth0_client.client.client_id
}

output "OIDC_CLIENT_SECRET" {
  value = {
    type   = "ssm"
    arn    = aws_ssm_parameter.client_secret.arn
    key    = aws_ssm_parameter.client_secret.name
    region = data.aws_region.current.name
  }
}

output "OIDC_ISSUER_URL" {
  value = "https://${data.auth0_tenant.current.domain}"
}

output "OIDC_DISCOVERY_URL" {
  value = "https://${data.auth0_tenant.current.domain}/.well-known/openid-configuration"
}

output "OIDC_LOGOUT_URL" {
  value = "https://${data.auth0_tenant.current.domain}/v2/logout"
}

output "OIDC_LOGOUT_REDIRECT_URL" {
  value = "${var.root_url}${var.logout_redirect_path}"
}

output "OIDC_CALLBACK_URL" {
  value = "${var.root_url}${var.callback_path}"
}

