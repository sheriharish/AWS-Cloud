#rote table creation
resource "aws_route_table" "rt" {
    vpc_id = var.vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = var.igw_id
    }
  
}

# variable block
variable "vpc_id"{}
variable "igw_id" {}

# output block
output "rt_id" {
    value = aws_route_table.rt.id
}   