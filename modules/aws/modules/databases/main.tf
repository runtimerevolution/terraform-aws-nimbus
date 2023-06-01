resource "aws_db_subnet_group" "subnet" {
  subnet_ids = var.subnets_ids
}

resource "aws_db_instance" "instance" {
  for_each = { for db in var.databases : db.engine => db }

  identifier                      = each.value.identifier
  allocated_storage               = coalesce(each.value.allocated_storage, 20)
  max_allocated_storage           = coalesce(each.value.max_allocated_storage, 0)
  instance_class                  = coalesce(each.value.instance_class, "db.t3.micro")
  engine                          = each.value.engine
  engine_version                  = each.value.engine_version
  db_name                         = coalesce(each.value.db_name, "${var.solution_name}_db")
  username                        = coalesce(each.value.username, var.solution_name)
  password                        = coalesce(each.value.password, var.solution_name)
  port                            = each.value.port
  multi_az                        = coalesce(each.value.multi_az, false)
  backup_retention_period         = coalesce(each.value.backup_retention_period, 0)
  backup_window                   = each.value.backup_window
  maintenance_window              = each.value.maintenance_window
  deletion_protection             = coalesce(each.value.deletion_protection, false)
  enabled_cloudwatch_logs_exports = each.value.enabled_cloudwatch_logs_exports
  storage_encrypted               = coalesce(each.value.storage_encrypted, false)
  storage_type                    = each.value.storage_type
  skip_final_snapshot             = coalesce(each.value.skip_final_snapshot, false)
  final_snapshot_identifier       = coalesce(each.value.final_snapshot_identifier, false)
  publicly_accessible             = coalesce(each.value.publicly_accessible, false)
  db_subnet_group_name            = aws_db_subnet_group.subnet.id
  vpc_security_group_ids          = [var.security_group_id]
}

# "identifier"              = "mysql-1"
# "allocated_storage"       = 5
# "max_allocated_storage"   = 10
# "backup_retention_period" = 2
# "multi_az"                = true
# "instance_class"          = "db.t3.micro"
# "db_name"                 = "worker_db"
# "username"                = "worker"
# "password"                = "password"
# "port"                    = "3306"
