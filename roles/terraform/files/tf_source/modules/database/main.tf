resource "postgresql_database" "db" {
  for_each          = postgresql_role.role
  name              = each.key
  owner             = each.value.name
  template          = "template0"
  lc_collate        = "en_US.utf8"
  connection_limit  = -1
  allow_connections = true
}

resource "postgresql_grant" "revoke_public_db" {
  for_each    = postgresql_database.db
  database    = each.value.name
  role        = "public"
  object_type = "database"
  privileges  = []
}

resource "postgresql_grant" "revoke_public_schema" {
  for_each    = postgresql_grant.revoke_public_db
  database    = postgresql_grant.revoke_public_db[each.key].database
  role        = "public"
  schema      = "public"
  object_type = "schema"
  privileges  = []
}