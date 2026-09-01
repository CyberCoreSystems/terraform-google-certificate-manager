# Certificate Manager certificate map — the routing object an external HTTPS
# load balancer attaches to so it can select among certificates by SNI hostname.
# A map applies standalone with nothing pre-existing, so this is the default
# (and live-test) path.
#
# Optional Google-managed certificate path: when var.domain is set the module
# also provisions a DNS authorization, a Google-managed certificate validated by
# that authorization, and a map entry binding the certificate to the hostname.
#
# NOTE: the Google-managed certificate path requires a REAL domain you control.
# You must publish the CNAME from `dns_authorization_record` before Google can
# issue the certificate. Leave var.domain null (the default) for the
# standalone certificate-map-only path.

resource "google_certificate_manager_certificate_map" "this" {
  project     = var.project_id
  name        = var.name
  description = var.description
  labels      = var.labels
}

resource "google_certificate_manager_dns_authorization" "this" {
  count       = var.domain != null ? 1 : 0
  project     = var.project_id
  name        = "${var.name}-dnsauth"
  domain      = var.domain
  description = "DNS authorization for ${var.domain}"
  labels      = var.labels
}

resource "google_certificate_manager_certificate" "this" {
  count       = var.domain != null ? 1 : 0
  project     = var.project_id
  name        = "${var.name}-cert"
  description = "Google-managed certificate for ${var.domain}"
  scope       = var.certificate_scope
  labels      = var.labels

  managed {
    domains            = [var.domain]
    dns_authorizations = [google_certificate_manager_dns_authorization.this[0].id]
  }
}

resource "google_certificate_manager_certificate_map_entry" "this" {
  count        = var.domain != null ? 1 : 0
  project      = var.project_id
  name         = "${var.name}-entry"
  map          = google_certificate_manager_certificate_map.this.name
  certificates = [google_certificate_manager_certificate.this[0].id]
  hostname     = var.domain
  labels       = var.labels
}
