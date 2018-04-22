
resource "aws_vpc" "main" {
  cidr_block = "192.168.0.0/16"
  tags {
    Name = "main"
  }
}

resource "aws_subnet" "lb-net-blue" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "192.168.1.0/24"
  availability_zone = "${var.az-blue}"

  tags {
    Name            = "lb-net-blue"
    Type            = "lb"
    Side            = "blue"
  }
}
resource "aws_subnet" "lb-net-green" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "192.168.2.0/24"
  availability_zone = "${var.az-green}"

  tags {
    Name            = "lb-net-green"
    Type            = "lb"
    Side            = "green"
  }
}

resource "aws_security_group" "lb-securitygroup" {
  vpc_id            = "${aws_vpc.main.id}"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0 
    to_port     = 443
    protocol    = "tcp"
  }
  tags {
    Name            = "lb-securitygroup"
  }
}

resource "aws_security_group" "bastion" {
  vpc_id            = "${var.vpc_id}"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0 
    to_port     = 22
    protocol    = "tcp"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0 
    to_port     = 0
    protocol    = "tcp"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0 
    to_port     = 0
    protocol    = "udp"
  }
  tags {
    Name            = "lb-securitygroup"
  }
}
