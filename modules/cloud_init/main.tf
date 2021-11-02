
data "template_file" "this" {
  template = file(var.script_path)
  vars = var.vars
}

data "template_cloudinit_config" "this" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.this.rendered
  }
}