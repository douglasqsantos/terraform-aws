# ID of the Volume
output "aws_ebs_volume_id" {
  value       = aws_volume_attachment.this.id
}
