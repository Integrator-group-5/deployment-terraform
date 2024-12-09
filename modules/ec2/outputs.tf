output "public_dns" {
  value       = aws_instance.app.public_dns
  description = "The public DNS of the EC2 instance."
}
