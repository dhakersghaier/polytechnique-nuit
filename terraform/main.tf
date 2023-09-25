provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "vue_app_security_group2" {
  name        = "vue-app-sg2"
  description = "Security group for the Vue.js application1"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "vue_app_instance" {
  ami           = "ami-04cb4ca688797756f"
  instance_type = "t2.micro"
  key_name      = var.key_name

  security_groups = [aws_security_group.vue_app_security_group2.name]

  tags = {
    Name = "VueAppInstance"
  }
}

output "ec2_instance_ip" {
  value = aws_instance.vue_app_instance.public_ip
}

