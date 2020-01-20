output "tfe_public_ip" {
  value = aws_instance.tfe.*.public_ip
}