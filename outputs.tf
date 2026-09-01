output "certificate_map_id" {
  description = "Fully-qualified certificate map ID (projects/.../certificateMaps/...)."
  value       = google_certificate_manager_certificate_map.this.id
}

output "certificate_map_name" {
  description = "The certificate map name (attach this to the target HTTPS proxy)."
  value       = google_certificate_manager_certificate_map.this.name
}

output "certificate_id" {
  description = "Fully-qualified ID of the Google-managed certificate, or null when no domain is configured."
  value       = try(google_certificate_manager_certificate.this[0].id, null)
}

output "dns_authorization_id" {
  description = "Fully-qualified ID of the DNS authorization, or null when no domain is configured."
  value       = try(google_certificate_manager_dns_authorization.this[0].id, null)
}

output "dns_authorization_record" {
  description = "CNAME record(s) to publish in your DNS so Google can validate the domain and issue the certificate. Empty when no domain is configured."
  value       = try(google_certificate_manager_dns_authorization.this[0].dns_resource_record, [])
}

output "certificate_map_entry_id" {
  description = "Fully-qualified ID of the certificate map entry, or null when no domain is configured."
  value       = try(google_certificate_manager_certificate_map_entry.this[0].id, null)
}
