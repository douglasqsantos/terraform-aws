# ID of existing security group whose rules we will manage
output "security_group_id" {
  value = aws_security_group.this.id
}