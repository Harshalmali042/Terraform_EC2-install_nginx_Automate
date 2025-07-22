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