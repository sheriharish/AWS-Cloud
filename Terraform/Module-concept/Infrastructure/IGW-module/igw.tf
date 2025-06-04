#internet gateway creation
resource "aws_internet_gateway"  "igw" {
    vpc_id = var.vpc_id
    tags = {
      name = var.igw_name
    }
}

# variable block
variable "vpc_id" {}
variable "igw_name" {}

# output block
output "igw_id" {
    value = aws_internet_gateway.igw.id
}
