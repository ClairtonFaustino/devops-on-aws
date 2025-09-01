output "intance_id" {
    value = aws_instance.srv_app_prod_1.id
    description = "ID da instância EC2"
}

output "instance_public_ip" {
    value = aws_instance.srv_app_prod_1.public_ip
    description = "Endereço IP público da instância EC2"
}

output "instance_public_dns" {
  description = "DNS público da instância EC2"
  value       = aws_instance.srv_app_prod_1.public_dns
}

output "ssh_connection" {
  description = "Comando para conectar via SSH"
  value       = "ssh ${var.ssh_user}@${aws_instance.srv_app_prod_1.public_ip}"
}

