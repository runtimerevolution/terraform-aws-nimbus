resource "aws_db_subnet_group" "subnet" {
  subnet_ids = var.subnets_ids
}

resource "aws_db_instance" "instance" {
  for_each = { for db in var.databases : db.identifier => db }

  identifier                      = each.value.identifier
  allocated_storage               = each.value.allocated_storage
  max_allocated_storage           = lookup(each.value, "max_allocated_storage", 0)
  instance_class                  = each.value.instance_class
  engine                          = each.value.engine
  engine_version                  = lookup(each.value, "engine_version", null)
  db_name                         = each.value.db_name
  username                        = each.value.username
  password                        = each.value.password
  port                            = lookup(each.value, "port", null)
  multi_az                        = lookup(each.value, "multi_az", false)
  backup_retention_period         = lookup(each.value, "backup_retention_period", 0)
  backup_window                   = lookup(each.value, "backup_window", null)
  maintenance_window              = lookup(each.value, "maintenance_window", null)
  deletion_protection             = lookup(each.value, "deletion_protection", false)
  enabled_cloudwatch_logs_exports = lookup(each.value, "enabled_cloudwatch_logs_exports", null)
  storage_encrypted               = lookup(each.value, "storage_encrypted", false)
  storage_type                    = lookup(each.value, "storage_type", null)
  skip_final_snapshot             = lookup(each.value, "skip_final_snapshot", false)
  final_snapshot_identifier       = lookup(each.value, "final_snapshot_identifier", false)
  publicly_accessible             = lookup(each.value, "publicly_accessible", false)
  db_subnet_group_name            = aws_db_subnet_group.subnet.id
  vpc_security_group_ids          = [var.security_group_id]
}
