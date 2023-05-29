resource "aws_db_subnet_group" "subnet" {
  subnet_ids = var.subnets_ids
}

resource "aws_db_instance" "instance" {
  for_each = var.databases

  identifier                = each.key                           # "mysql"
  allocated_storage         = each.value.allocated_storage       # 5
  backup_retention_period   = each.value.backup_retention_period # 2
  backup_window             = each.value.backup_window           # "01:00-01:30"
  maintenance_window        = each.value.maintenance_window      # "sun:03:00-sun:03:30"
  multi_az                  = each.value.multi_az                # true
  engine                    = each.value.engine                  # "mysql"
  engine_version            = each.value.engine_version          # "5.7"
  instance_class            = each.value.instance_class          # "db.t2.micro"
  db_name                   = each.value.db_name                 # "worker_db"
  username                  = each.value.username                # "worker"
  password                  = each.value.password                # "worker"
  port                      = each.value.port                    # "3306"
  db_subnet_group_name      = aws_db_subnet_group.subnet.id
  vpc_security_group_ids    = [var.security_group_id]
  skip_final_snapshot       = each.value.skip_final_snapshot                  # true
  final_snapshot_identifier = each.value.final_snapshot_identifier            # "worker-final"
  publicly_accessible       = lookup(each.value, "publicly_accessible", true) # true
}
