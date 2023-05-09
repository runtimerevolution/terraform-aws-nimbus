data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.aws_ami_name]
  }

  filter {
    name   = "virtualization-type"
    values = [var.aws_virtualization_type]
  }

  owners = [var.aws_ami_owner]
}