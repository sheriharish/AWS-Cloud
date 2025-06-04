#load balancer creation
resource "aws_lb" "my_lb" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "network"
  security_groups    = var.sg_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = var.lb_name
  }
}

# variable block
variable "lb_name" {}
variable "sg_ids" {}
variable "subnet_ids" {}

# output block
output "lb_arn" {
  value = aws_lb.my_lb.arn
}