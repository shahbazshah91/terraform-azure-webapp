output "vm_private_key" {
  value     = tls_private_key.vm_ssh.private_key_openssh
  sensitive = true
}

output "mysql_admin_password" {
  value     = random_password.mysql_admin.result
  sensitive = true
}