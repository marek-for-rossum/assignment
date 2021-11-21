resource "random_password" "password" {
  for_each         = local.database_instances
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "postgresql_role" "role" {
  for_each    = random_password.password
  login       = true
  name        = local.database_instances[each.key].owner
  password    = random_password.password[each.key].result
  search_path = []
  roles       = []
}

resource "postgresql_grant" "allow_all" {
  for_each    = postgresql_database.db
  database    = each.value.name
  role        = postgresql_role.role[each.key].name
  object_type = "database"
  privileges  = ["CONNECT", "CREATE", "TEMPORARY"]
  depends_on = [
    postgresql_grant.revoke_public_db,
  ]
}

resource "postgresql_grant" "allow_usage_public_schema" {
  for_each    = postgresql_grant.allow_all
  database    = postgresql_grant.allow_all[each.key].database
  role        = postgresql_grant.allow_all[each.key].role
  schema      = "public"
  object_type = "schema"
  privileges  = ["CREATE", "USAGE"]
  depends_on = [
    postgresql_grant.revoke_public_schema,
  ]
}