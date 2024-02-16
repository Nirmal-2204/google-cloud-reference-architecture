resource "random_string" "cloudsql_database_name" {
  length  = 10
  special = false
  lower   = true
  upper   = false
}

resource "random_string" "cloudsql_user_name" {
  length  = 10
  special = false
  lower   = true
  upper   = false
}

resource "random_string" "cloudsql_user_password" {
  length  = 10
  special = true
  lower   = true
  upper   = true
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/sql_database_instance
data "google_sql_database_instance" "instance" {
  name = var.instance_name
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database
resource "google_sql_database" "database" {
  name     = "database-${random_string.cloudsql_database_name.result}"
  instance = var.instance_name
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user
resource "google_sql_user" "user" {
  name     = random_string.cloudsql_user_name.result
  instance = google_sql_database_instance.instance.name
  password = random_string.cloudsql_user_password.result
}
