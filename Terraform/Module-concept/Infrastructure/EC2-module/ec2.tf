# create the EC2 instance
resource "aws_instance" "ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  associate_public_ip_address = true

  tags = {
    Name = var.instance_name
  }
}


# variable block
variable "ami_id" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "sg_id" {}     
variable "instance_name" {}


# output block
output "ec2_instance_id" {
  value = aws_instance.ec2_instance.id
}