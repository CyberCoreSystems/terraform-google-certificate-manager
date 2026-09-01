terraform {
  required_version = ">= 1.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 7.0, < 8.0"
    }
  }
}

provider "google" {
  project = "iacbazaar-example-project"
  region  = "us-central1"
}

# Standalone certificate map — attach to a target HTTPS proxy and add entries
# (or set var.domain to also provision a Google-managed certificate).
module "certificate_map" {
  source = "../../"

  project_id = "iacbazaar-example-project"
  name       = "example-certmap"

  labels = {
    environment = "example"
    managed_by  = "iac-bazaar"
  }
}

output "certificate_map_id" {
  value = module.certificate_map.certificate_map_id
}

# To provision a Google-managed certificate, supply a domain you control and
# publish module.managed_certs.dns_authorization_record in your DNS:
#
# module "managed_certs" {
#   source     = "../../"
#   project_id = "iacbazaar-example-project"
#   name       = "example-managed"
#   domain     = "api.example.com"
# }
