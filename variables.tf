variable "project_id" {
  description = "GCP project ID hosting the certificate map and (optionally) the managed certificate."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "project_id must be a valid GCP project ID (6-30 chars, lowercase letters, digits, hyphens)."
  }
}

variable "name" {
  description = "Certificate map name. Also prefixes the DNS authorization, certificate and map-entry names when a domain is supplied."
  type        = string

  validation {
    condition     = can(regex("^[a-z]([a-z0-9-]{0,61}[a-z0-9])?$", var.name))
    error_message = "name must start with a letter, contain only lowercase letters, digits and hyphens, and be at most 63 characters."
  }
}

variable "description" {
  description = "Human-readable description for the certificate map."
  type        = string
  default     = "Managed by IaC Bazaar gcp-certificate-manager"
}

variable "domain" {
  description = "Domain to provision a Google-managed certificate for (e.g. api.example.com). REQUIRES a real domain you control: you must publish the CNAME exported as dns_authorization_record before the certificate can be issued. Null (default) provisions only the standalone certificate map."
  type        = string
  default     = null

  validation {
    condition     = var.domain == null || can(regex("^([a-z0-9*]([a-z0-9-]{0,61}[a-z0-9])?\\.)+[a-z]{2,}$", var.domain))
    error_message = "domain must be a valid fully-qualified domain name (e.g. api.example.com) or a wildcard (e.g. *.example.com)."
  }
}

variable "certificate_scope" {
  description = "Scope of the Google-managed certificate (used only when domain is set): DEFAULT (global external ALB), EDGE_CACHE (Media CDN) or ALL_REGIONS."
  type        = string
  default     = "DEFAULT"

  validation {
    condition     = contains(["DEFAULT", "EDGE_CACHE", "ALL_REGIONS"], var.certificate_scope)
    error_message = "certificate_scope must be DEFAULT, EDGE_CACHE or ALL_REGIONS."
  }
}

variable "labels" {
  description = "Labels applied to all created resources (lowercase keys/values per GCP label rules)."
  type        = map(string)
  default     = {}
}
