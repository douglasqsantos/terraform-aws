# output "key_name" {
#   description = "SSH Key Name"
#   value = concat(
#     aws_key_pair.this.*.key_name,
#     [""],
#   )[0]
# }
output "key_name" {
  description = "SSH Key Name"
  value       = aws_key_pair.this.key_name
}
