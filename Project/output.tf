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