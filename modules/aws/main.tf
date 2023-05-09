resource "aws_resourcegroups_group" "test_resource_group" {
  name = "ExampleResourceGroup"

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::EC2::Instance"
  ],
  "TagFilters": [
    {
      "Key": "Name",
      "Values": ["ExampleAppServerInstance"]
    }
  ]
}
JSON
  }
}

resource "aws_instance" "test_app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}
