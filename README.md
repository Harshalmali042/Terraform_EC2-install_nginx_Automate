# Terraform_EC2-install_nginx_Automate
- Terraform is used to launch Ec2 instance Automatically.
- for instance Created default VPC , Security group , and key.
- Automate thic Instance for install Nginx From Shell script file.


## terraform.tf file
```
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.4.0"
    }
  }

}
```

## provider.tf file
```
provider "aws" {
    region = "us-east-1"
}
```

## EC2.tf file  or  (main.tf file)
```
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
```

## variables.tf
```
# instance
variable "ec2_instance_type" {
    default = "t2.micro"
    type = string
}

# Root volume
variable "ec2_root_storage_size" {
    default = 14
    type = number
}

# Ubantu Linux
variable "ec2_ami_id" {
    default = "ami-020cba7c55df1f615" #ubantu
    type = string
}
```
## Output.tf file
```
# Public ip address
output "ec2_public_ip"{
    value = aws_instance.my_instance.public_ip
}

# public DNS 
output "ec2_public_dns"{
    value = aws_instance.my_instance.public_dns
}

# private IP 
output "ec2_private_ip"{
    value = aws_instance.my_instance.private_ip
}
```

## Install-Nginx.sh (Shell Script file)
```
#!/bin/bash

sudo apt-get update
sudo apt-get install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

echo "<h1> Terraform is Fully Automated </h1>" > /var/www/html/index.html

```

