#target group creation
resource "aws_lb_target_group" "tg" {
    name     = var.tg_name
    port     = var.port
    protocol = var.protocol
    vpc_id   = var.vpc_id
    
    health_check {
       protocol = var.health_check_protocol
    }
    
    tags = {
        Name = var.tg_name
    }
}

# variable block
variable "tg_name" {}
variable "port" {}  
variable "protocol" {}
variable "vpc_id" {}
variable "health_check_protocol" {}

# output block
output "tg_arn" {
    value = aws_lb_target_group.tg.arn
}