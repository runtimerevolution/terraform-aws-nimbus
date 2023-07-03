resource "aws_secretsmanager_secret" "bastion_ssh_private_key" {
  count                   = var.enable_secrets_manager ? 1 : 0
  
  name                    = "${var.solution_name}-bastion-private-key"
  description             = "Bastion Host private key"
  recovery_window_in_days = var.environment == "Production" ? 30 : 0

  depends_on = [tls_private_key.bastion]
}

resource "aws_secretsmanager_secret_version" "bastion_ssh_private_key" {
  count = var.enable_secrets_manager ? 1 : 0

  secret_id     = aws_secretsmanager_secret.bastion_ssh_private_key[0].id
  secret_string = tls_private_key.bastion.private_key_pem
}
