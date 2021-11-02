
output "rendered" {
  description = "Script rendered"
  value       = data.template_cloudinit_config.this.rendered
}
