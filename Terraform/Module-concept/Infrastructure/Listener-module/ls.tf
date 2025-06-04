#creation of listener for load balancer
resource "aws_lb_listener" "listener" {
  load_balancer_arn = var.lb_arn
  port              = var.port
  protocol          = var.protocol

  default_action {
    type             = "forward"
    target_group_arn = var.tg_arn
  }
}

# variable block
variable "lb_arn" {}
variable "port" {}
variable "protocol" {}
variable "tg_arn" {}            
