resource "aws_security_group" "san_sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.env_pre}-sg"
  }
}

resource "aws_key_pair" "san_keypair" {
	key_name = "${env_pre}-key"
	public_key = file(var.public_key_location)
}
data "aws_ami" "san_ami" {
	most_recent = true
	virtualization_type = "hvm"
	name = ["Amazon Linux 2 Kernel 5.10 AMI 2.0.20221210.1 x86_64 HVM gp2"]
}

resource "aws_instance" "san_instance" {
	ami = data.aws_ami.san_ami.id
	instance_type = t2.micro
	subnet_id = var.subnet_id
	vpc_security_group_ids = [aws_security_group.san_sg.id]
	availability_zone = var.avail_zone
	associate_public_ip_address = true
	key_name = aws_key_pair.san_keypair.key_name

	user_data = file("entrypoint.sh")
	tags = {
	 Name = "${var.env_pre}-instance"
	}
}