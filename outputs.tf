output "ec2_instance_public_dns" {
  value = module.ec2.public_dns
  description = "Public DNS of the EC2 instance hosting the application."
}

output "frontend_url" {
  value = "http://${module.ec2.public_dns}:3000"
  description = "URL to access the frontend of the application."
}

output "connect_instance" {
  value = "ssh -i ${var.key_name} ec2-user@${module.ec2.public_dns}"
  description = "Command to ssh to the ec2 instance."
}
