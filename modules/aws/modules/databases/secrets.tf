resource "aws_secretsmanager_secret" "db_credentials" {
  count = var.enable_secrets_manager ? length(var.databases) : 0

  name                    = "${var.solution_name}-${aws_db_instance.instance[count.index].identifier}-db-credentials"
  description             = "Database '${aws_db_instance.instance[count.index].identifier}' credentials"
  recovery_window_in_days = var.environment == "Production" ? 30 : 0
}

resource "aws_secretsmanager_secret_version" "bastion_ssh_private_key" {
  count = var.enable_secrets_manager ? length(var.databases) : 0

  secret_id     = aws_secretsmanager_secret.db_credentials[count.index].id
  secret_string = <<EOF
  {
    "username": "${aws_db_instance.instance[count.index].username}",
    "password": "${aws_db_instance.instance[count.index].password}"
  }
EOF
}
