# AMI ID
output "ami_id" {
  value = data.aws_ami.this.id
}