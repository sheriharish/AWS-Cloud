#subnet creation
resource "aws_subnet" "My_subnets" {
    vpc_id = var.vpc_id
    cidr_block = var.cidr_block
    availability_zone = var.availability_zone
    map_public_ip_on_launch = true
    
    tags = {
        Name = var.subnet_name
    }
  
}

#variable block
variable "vpc_id" {}
variable "cidr_block" {}
variable "availability_zone" {}
variable subnet_name {} 

#output block
output "subnet_id" {
    value = aws_subnet.My_subnets.id
}

  
