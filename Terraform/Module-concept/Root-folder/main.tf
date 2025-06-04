#provider block
provider "aws" {
    region = "us-east-2"
    access_key = 
    secret_key = 
}

#module for VPC creation
module "vpc" {
    source = "../Infrastructure/VPC-module"
    cidr_block = "10.10.0.0/16"
    vpc_name = "VPC-01"

} 

#subnet module
module "subnets"{
    source = "../Infrastructure/Subnets-module"

    for_each = {
        subnet1 = {
            cidr_block = "10.10.1.0/24"
            availability_zone = "us-east-2a"
            subnet_name = "subnet1"
        },
        subnet2 = {
            cidr_block = "10.10.2.0/24"
            availability_zone = "us-east-2b"
            subnet_name = "subnet2"
        },

    }
    vpc_id = module.vpc.vpc_id
    cidr_block = each.value.cidr_block
    availability_zone = each.value.availability_zone    
    subnet_name = each.value.subnet_name
} 
#output block for subnets
output "subnet_ids" {
    value = {
        subnet1 = module.subnets["subnet1"].subnet_id
        subnet2 = module.subnets["subnet2"].subnet_id
    }
}  

#module for IGW creation
module "IGW" {
    source = "../Infrastructure/IGW-module"
    vpc_id = module.vpc.vpc_id
    igw_name = "IGW-01"
}

#module for RT creation
module "RT" {
    source ="../Infrastructure/RT-module"
    vpc_id = module.vpc.vpc_id
    igw_id = module.IGW.igw_id
}

#associate route table with subnets" 
resource "aws_route_table_association" "subnet1_asso" {
    subnet_id = module.subnets["subnet1"].subnet_id
    route_table_id = module.RT.rt_id
}

#associate route table with subnet2
resource "aws_route_table_association" "subnet2_asso" {
    subnet_id = module.subnets["subnet2"].subnet_id
    route_table_id = module.RT.rt_id
}

#security group creation
module "SG" {
    source = "../Infrastructure/SG-module"
    vpc_id = module.vpc.vpc_id
    sg_name = "SG-01"
    from_port = 0
    to_port = 0
    protocol = "-1"              # -1 means all protocols
    cidr_block = ["0.0.0.0/0"]   # Allow all IPs
    
}

#EC2 instance creation using for_each
module "named_ec2" {
    source = "../Infrastructure/EC2-module"

    for_each = {
        ec2_instance1 = {
            ami_id = "ami-04f167a56786e4b09"
            instance_type = "t2.micro"
            subnet_id = module.subnets["subnet1"].subnet_id    
            sg_id = module.SG.sg_id
            instance_name = "Instance-1"
            key_name      = "demo" 
        },
        ec2_instance2 = {
            ami_id = "ami-04f167a56786e4b09"
            instance_type = "t2.micro"
            subnet_id = module.subnets["subnet2"].subnet_id    
            sg_id = module.SG.sg_id
            instance_name = "Instance-2"
            key_name      = "demo" 
        },
    }
    ami_id = each.value.ami_id
    instance_type = each.value.instance_type    
    subnet_id = each.value.subnet_id
    sg_id = each.value.sg_id
    instance_name = each.value.instance_name
  
}

#load balancer creation
module "LB" {
    source = "../Infrastructure/LB-module"
    lb_name = "LB-01"
    sg_ids = [module.SG.sg_id]
    subnet_ids = [
        module.subnets["subnet1"].subnet_id,
        module.subnets["subnet2"].subnet_id
    ]
}

#targer group creation
module "target_group" {
    source = "../Infrastructure/TG-module"
    tg_name = "TG-01"
    port = 80
    protocol = "TCP"
    vpc_id = module.vpc.vpc_id
    health_check_protocol = "HTTP"
}

#register targets with target group
resource "aws_lb_target_group_attachment" "tg_attachment" {
    for_each = {
        instance1 = module.named_ec2["ec2_instance1"].ec2_instance_id
        instance2 = module.named_ec2["ec2_instance2"].ec2_instance_id
    }
    target_group_arn = module.target_group.tg_arn
    target_id = each.value
    port = 80
}

#listener creation
module "listener" {
    source = "../Infrastructure/Listener-module"
    lb_arn = module.LB.lb_arn
    port = 80
    protocol = "TCP"
    tg_arn = module.target_group.tg_arn
}

