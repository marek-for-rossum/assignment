resource "random_password" "password_ro" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "postgresql_role" "role_ro" {
  login       = true
  name        = "read_only"
  password    = random_password.password_ro.result
  search_path = []
  roles       = []
}

resource "postgresql_grant" "allow_connect_all" {
  for_each    = postgresql_database.db
  database    = each.value.name
  role        = postgresql_role.role_ro.name
  object_type = "database"
  privileges  = ["CONNECT"]
  depends_on = [
    postgresql_grant.allow_all,
  ]
}

resource "postgresql_grant" "allow_select_ro" {
  for_each    = postgresql_database.db
  database    = each.value.name
  role        = postgresql_role.role_ro.name
  schema      = "public"
  object_type = "table"
  privileges  = ["SELECT"]
}