# creation of security group module
resource "aws_security_group" "sg" {
    vpc_id = var.vpc_id
    name   = var.sg_name

    ingress {
        from_port   = var.from_port
        to_port     =var.to_port
        protocol    = var.protocol # -1 means all protocols
        description = "Allow all inbound traffic"
        cidr_blocks = var.cidr_block # Allow all IPs
    }
    egress {
        from_port   =var.from_port
        to_port     = var.to_port
        protocol    = var.protocol # -1 means all protocols
        description = "Allow all outbound traffic"
        cidr_blocks = var.cidr_block # Allow all IPs
    }
      
}

# variable block
variable "vpc_id" {}
variable "sg_name" {}
variable "from_port" {}
variable "to_port" {}
variable "protocol" {}
variable "cidr_block" {}

# output block
output "sg_id" {
    value = aws_security_group.sg.id
}