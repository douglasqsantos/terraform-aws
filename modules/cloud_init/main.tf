# https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file
# The template_file data source renders a template from a template string, which is usually loaded from an external file.
data "template_file" "this" {
  # (Required) The contents of the template, as a string using Terraform template syntax.
  # Use the file function to load the template source from a separate file on disk.
  template = file(var.script_path)
  # (Optional) Variables for interpolation within the template.
  # Note that variables must all be primitives. Direct references to lists or maps will cause a validation error.
  vars = var.vars
}

# https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/cloudinit_config
# Cloud-init is a commonly-used startup configuration utility for cloud compute instances.
# It accepts configuration via provider-specific user data mechanisms, such as user_data for Amazon EC2 instances.
# Multipart MIME is one of the data formats it accepts. For more information, see User-Data Formats in the Cloud-init manual.
data "template_cloudinit_config" "this" {
  # (Optional) Specify whether or not to gzip the rendered output. Defaults to true.
  gzip          = false
  # (Optional) Base64 encoding of the rendered output. Defaults to true, and cannot be disabled if gzip is true.
  base64_encode = false

  # (Required) A nested block type which adds a file to the generated cloud-init configuration.
  # Use multiple part blocks to specify multiple files, which will be included in order of declaration in the final MIME document.
  part {
    # (Optional) A MIME-style content type to report in the header for the part.
    content_type = "text/x-shellscript"
    # (Required) Body content for the part.
    content      = data.template_file.this.rendered
  }
}
