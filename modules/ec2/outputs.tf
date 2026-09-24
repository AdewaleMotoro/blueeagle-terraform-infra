# modules/ec2/outputs.tf

output "instance_id" {
  description = "ID of the created EC2 instance."
  value       = aws_instance.app.id
}

output "public_ip" {
  description = "Public IP address of the instance."
  value       = aws_eip.app.public_ip
}

output "private_ip" {
  description = "Private IP address of the instance."
  value       = aws_instance.app.private_ip
}

output "security_group_id" {
  description = "ID of the instance's security group."
  value       = aws_security_group.app.id
}

output "ssh_command" {
  description = "SSH command to connect to the instance."
  value       = "ssh -i <path-to-key>.pem ubuntu@${aws_eip.app.public_ip}"
}