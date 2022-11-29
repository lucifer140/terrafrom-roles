output "encrypted_pass" {
  value = module.roles.encrypted_password
}

output "pass" {
  value = module.roles.password
}
