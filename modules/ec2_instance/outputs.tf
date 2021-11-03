# The public IP address assigned to the instance, if applicable.
# NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly
# and not use public_ip as this field will change after the EIP is attached.
output "public_ip" {
  value = aws_instance.this.public_ip
}

# The ID of the instance
output "ec2_instance_id" {
  value = aws_instance.this.id
}
