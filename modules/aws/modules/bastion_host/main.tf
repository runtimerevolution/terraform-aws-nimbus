# -----------------------------------------------------------------------------
# IAM instance profile
# -----------------------------------------------------------------------------
resource "aws_iam_instance_profile" "bastion" {
  name = "${var.solution_name}-bastion"
  role = aws_iam_role.bastion.name
}

resource "aws_iam_role" "bastion" {
  name               = "${var.solution_name}-bastion"
  assume_role_policy = data.aws_iam_policy_document.bastion.json
}

resource "aws_iam_role_policy_attachment" "bastion_ec2_instance_connect" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceConnect"
}

# -----------------------------------------------------------------------------
# Launch template
# -----------------------------------------------------------------------------
resource "tls_private_key" "bastion" {
  algorithm = "RSA"
}

resource "aws_key_pair" "bastion" {
  key_name   = "bastion"
  public_key = tls_private_key.bastion.public_key_openssh

  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.bastion.private_key_pem}' > ${var.solution_name}-bastion.pem
      chmod 400 ${var.solution_name}-bastion.pem
    EOT
  }
}

resource "aws_security_group" "bastion" {
  name   = "${var.solution_name}-bastion"
  vpc_id = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_launch_template" "bastion" {
  name = "${var.solution_name}-bastion"

  key_name = aws_key_pair.bastion.key_name

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 20
    }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  disable_api_termination = false
  ebs_optimized           = true

  iam_instance_profile {
    name = aws_iam_instance_profile.bastion.name
  }

  image_id                             = coalesce(var.ami_id, data.aws_ami.default.id)
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = var.instance_type

  network_interfaces {
    security_groups = [aws_security_group.bastion.id]
  }

  monitoring {
    enabled = true
  }
}


# -----------------------------------------------------------------------------
# AWS autoscaling group
# -----------------------------------------------------------------------------
resource "aws_autoscaling_group" "bastion" {
  name = "${var.solution_name}-bastion"

  desired_capacity = 1
  max_size         = 1
  min_size         = 1

  vpc_zone_identifier = var.subnets_ids

  launch_template {
    id      = aws_launch_template.bastion.id
    version = aws_launch_template.bastion.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }
}
