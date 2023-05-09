resource "aws_resourcegroups_group" "resource_group" {
  name = var.aws_resource_group_name

  resource_query {
    query = var.aws_resource_group_query
  }
}

resource "aws_instance" "instance" {
  ami           = data.aws_ami.ami.id
  instance_type = var.aws_instance_type

  tags = {
    Name = var.aws_instance_name
  }
}