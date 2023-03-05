provider "aws" {
  region = "us-east-1"
}

/**
Create a new EC2instance
*/
resource "aws_instance" "example" {
  ami           = "ami-006dcf34c09e50022"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  /* when user_data is changed, terraform will terminate the instance
     the original instance and launch a totally new one */
  user_data_replace_on_change = true

  tags = {
    Name = "terraform-example"
  }
}

/*
Create a security group
*/
resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}