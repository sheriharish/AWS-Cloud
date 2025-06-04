// VPC module for creating a Virtual Private Cloud (VPC) in AWS
resource "aws_vpc" "my_vpc"{
    cidr_block = var.cidr_block
    
    tags = {
      name = var.vpc_name
    }
}

# variable block
variable "cidr_block" {}
variable "vpc_name" {}

# output block
output "vpc_id" {
    value = aws_vpc.my_vpc.id
}
