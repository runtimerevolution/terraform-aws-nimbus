resource "aws_secretsmanager_secret" "bastion_ssh_private_key" {
  name        = "${var.solution_name}-bastion-private-key"
  description = "Bastion Host private key"
  recovery_window_in_days = 0

  depends_on = [tls_private_key.bastion]
}

resource "aws_secretsmanager_secret_version" "bastion_ssh_private_key" {
  secret_id     = aws_secretsmanager_secret.bastion_ssh_private_key.id
  secret_string = tls_private_key.bastion.private_key_pem
}
