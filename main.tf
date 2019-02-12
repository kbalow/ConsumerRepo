#testing Sentinel
data "terraform_remote_state" "network" {
  backend = "atlas"

  config {
    name = "${var.org}/${var.workspace_name}"
  }
}

provider "aws" {
  region = "${data.terraform_remote_state.network.region}"  
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

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.large"
  subnet_id = "${data.terraform_remote_state.network.prod_subnet_id}"

  tags {
    Name = "Production Instance"
  }
}
