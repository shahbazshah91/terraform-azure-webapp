output "vm_private_key" {
  value     = tls_private_key.vm_ssh.private_key_openssh
  sensitive = true
}