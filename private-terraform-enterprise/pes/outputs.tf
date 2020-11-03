output "ptfe_fqdn" {
  value = aws_route53_record.pes.fqdn
}

output "ptfe_public_ip" {
  value = aws_instance.primary[0].public_ip
}

output "ptfe_private_ip" {
  value = aws_instance.primary[0].private_ip
}

output "ptfe_public_dns" {
  value = aws_instance.primary[0].public_dns
}

output "ptfe_private_dns" {
  value = aws_instance.primary[0].private_dns
}

