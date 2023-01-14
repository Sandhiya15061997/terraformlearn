resource "aws_subnet" "san_subnet-1" {
	vpc_id = var.vpc_id
	cidr_block = var.subnet_cidr
	availability_zone = var.avail_zone
	tags {
	 Name = "${var.env_pre}-subnet"
	}
}

resource "aws_internet_gateway" "san_igw" {
	vpc_id = var.vpc_id
	tags {
	 Name = "${var.env_pre}-igw"
	}
}

resource "aws_route_table" "san_rt" {
	vpc_id = var.vpc_id
	gateway_id = var.gwid
	tags = {
      Name = "${var.env_pre}-rt"
	}
}

resource "aws_route_table_association" "san_rtb" {
	subnet_id = var.subnet_id
	route_table_id = var.rt_id
}