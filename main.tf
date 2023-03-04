provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "app" {
  instance_type     = "t2.micro"
  availability_zone = "us-east-2a"
  ami               = "ami-0c55b159cbfafe1f0"
#  depends_on   = [ aws_instance.app2 ]
  user_data = <<-EOF
    #!/bin/bash
    echo "hello, world" > index.html
    nohup busybox httpd -f -p 8080 &
    sleep 5
  EOF
}

data "external" "echo" {
  program = ["bash", "-c", "cat /dev/stdin"]
  query = {
     foo = "bar"
  }
}

resource "aws_instance" "app2" {
  instance_type     = "t2.micro"
  availability_zone = "us-east-2a"
  ami               = "ami-0c55b159cbfafe1f0"

  user_data = <<-EOF
    #!/bin/bash
    echo "hello, world" > index.html
    nohup busybox httpd -f -p 8080 &
    sleep 5
  EOF
}


output "app_public-ip" {
  value = aws_instance.app.public_ip
}

output "app2_public-ip" {
  value = aws_instance.app2.public_ip
}

