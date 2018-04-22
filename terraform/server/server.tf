resource "aws_key_pair" "main-key" {
  key_name   = "main-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDLmEY2/2EKY/qAX09kUJCDaKFn6hgHyT5jeFmek/UxgQFlYmdGvf15ubytXp8FOFrlU4Zrk6wE+wvbre7SAweK0+juBdv/YCrXnoKTO+RfX9aiF53WIN4FPs4IrT9HHS+cdHuQo5BBgXnIBlrOkbsSN9tMHAQLDNcxybmVISBemzMj5z6ra79ZALLWDlVFVhfLJ8ATj8jIe9W4hTMlLzJBIqmfTYkAN86TpAgv/c3b9rHvohV57XP7eorhYbuek+Tf4gm5SgPntEVGlmxbsYOaFa0texnNTDefyIdUPjdGFn7sPd6PoqVBy/q7souln7jm31ApfZHva3KjCfG/dTTA8fCVvKlDaAxLWIlYHaPME+PwoymGB4zi5H06mcrwIDEePau4ePaVERf1DI2oszDd1yHWoXLFw1SsD461nwy3IXH0qB/pQrmSXc+XllbOSdyexPrc6BHXqnxaDI7eMW8XniJbqS6d4IPvVhMkR8iRCexT2+aLk1n2Uh0WfxRUcoRTNq1HqM/ALrI8nMTumBk6YwlNRkFjhFCJs0WYu9GezaBMMNoWhb+xRVvID59KqlF0nQcyOo6Ohqr98Ne6nUIR6PU5N5/x8pfZpbdn92NylGIz+xygF2g6+zDwUANt2z9AzqwwIUxuGO+djHbKMx7WDJKvIWHrIZN1XLK/7Sq5RQ== bboortz"
}


resource "aws_instance" "lb-blue" {
  ami             = "${var.lb-instance-flavor}"
  instance_type   = "t2.micro"
  subnet_id       = "${aws_subnet.lb-net-blue.id}"
  security_groups = ["${aws_security_group.lb-securitygroup.id}"]
  key_name        = "${aws_key_pair.main-key.key_name}"
  tags {
    Name          = "lb-blue"
    Type          = "lb"
    Side          = "blue"
    Group         = "lb"
    is_bastion    = "False"
    
  }
}


resource "aws_instance" "lb-green" {
  ami             = "${var.lb-instance-flavor}"
  instance_type   = "t2.micro"
  subnet_id       = "${aws_subnet.lb-net-green.id}"
  security_groups = ["${aws_security_group.lb-securitygroup.id}"]
  key_name        = "${aws_key_pair.main-key.key_name}"
  tags {
    Name          = "lb-green"
    Type          = "lb"
    Side          = "green"
    Group         = "lb"
    is_bastion    = "False"
    
  }
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "bastion" {
  ami             = "${data.aws_ami.ubuntu.id}"
  instance_type   = "t2.micro"
#  security_groups = ["${aws_security_group.bastion.id}"]
  key_name        = "${aws_key_pair.main-key.key_name}"

  tags {
    Name          = "bastion"
    Type          = "bastion"
    Side          = "-"
    Group         = "bastion"
    is_bastion    = "True"
  }
}
