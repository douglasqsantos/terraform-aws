# The final rendered multi-part cloud-init config.
output "rendered" {
  value       = data.template_cloudinit_config.this.rendered
}
