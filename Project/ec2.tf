# key pair (login)
resource  aws_key_pair my_key {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

# VPC & Security Group

resource aws_default_vpc default {

}

resource aws_security_group  my_SG {
  name        = "automate-SG"
  description = "This will create a security group"
  vpc_id      = aws_default_vpc.default.id #interpolation

    # inbound rules
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "SSH open"
    }

     ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTP open"
    }

     ingress {
        from_port = 8000
        to_port = 8000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "flask app"
    }


    # outbound rules

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = " Open Access to All"
    }


    tags = {
        Name = "automate-SG"
  }
}


# ec2 instance

resource "aws_instance" "my_instance" {
    key_name        = aws_key_pair.my_key.key_name 
    security_groups = [aws_security_group.my_SG.name]
    instance_type   = var.ec2_instance_type
    ami             = var.ec2_ami_id  # ubantu
    user_data       = file("install_nginx.sh")

    root_block_device {
        volume_size = var.ec2_root_storage_size
        volume_type = "gp3"
    }

     tags = {
        Name = "Terra-Server-Automate"
  }
}