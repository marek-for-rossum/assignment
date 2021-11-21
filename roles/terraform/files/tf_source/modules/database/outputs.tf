output "name" {
  value = tomap({
    for k, inst in postgresql_role.role : k => inst.name
  })
  description = "DB admin username"
}

output "password" {
  value = tomap({
    for k, inst in postgresql_role.role : k => inst.password
  })
  description = "DB admin password"
}

output "name_ro" {
  value = postgresql_role.role_ro.name
  description = "DBs read_only username"
}

output "password_ro" {
  value = postgresql_role.role_ro.password
  description = "DB read_only password"
}