data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = lookup(var.ami, "most_recent", true)
  owners = lookup(var.ami, "owners", null)

  filter {
    name   = "name"
    values = [var.ami.name]
  }
}
