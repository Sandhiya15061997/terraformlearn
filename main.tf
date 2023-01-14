provider "aws" {
	region = "us-east-1"
}



resource "aws_vpc" "san_vpc" {
	cidr_block = var.vpc_cidr
	tags = {
	  Name = "${var.env_pre}-vpc"
	}
}

module "san_subnet-1" {
	source = "./modules/subnet"
	subnet_cidr = var.subnet_cidr
	avail_zone = var.avail_zone
	env_pre = var.env_pre
	vpc_id = aws_vpc.san_vpc.id
	rt_id = var.rt_id
}

module "san_instance" {
	source = "./modules/server"
    vpc_id = aws_vpc.san_vpc.id
    avail_zone = var.avail_zone
    env_pre = var.env_pre
    subnet_id = module.san_subnet-1.subnet_o.id
    public_key_location = var.public_key_location
    instance_type = var.instance_type
    my_ip = var.my_ip
}