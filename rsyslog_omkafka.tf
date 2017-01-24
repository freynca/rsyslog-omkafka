variable "ubuntu-1604-lts-ebs-hvm-ami-map" {
  type = "map"

  default = {
    us-west-2 = "ami-7c803d1c"
  }
}

variable "security_group_id" {
  type = "string"
}
variable "subnet_id" {
  type = "string"
}
variable "region" {
  type = "string"
}
variable "keyname" {
  type = "string"
}
variable "access_key_id" {
  type = "string"
}
variable "secret_access_key" {
  type = "string"
}

variable "user" {
  type    = "string"
  default = "ubuntu"
}

variable "relative_key_path" {
  type    = "string"
}

provider "aws" {
    access_key = "${var.access_key_id}"
    secret_key = "${var.secret_access_key}"
    region = "${var.region}"
}

resource "aws_instance" "rsyslog_omkafka" {
  ami = "${lookup(var.ubuntu-1604-lts-ebs-hvm-ami-map, var.region)}"
  instance_type = "t2.medium"
  key_name = "${var.keyname}"
  vpc_security_group_ids = ["${var.security_group_id}"]
  source_dest_check = false
  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true

  provisioner "file" {
       source = "${path.cwd}/rsyslog_omkafka.sh"
       destination = "/tmp/rsyslog_omkafka.sh"

       connection {
            type = "ssh"
            user = "${var.user}"
            private_key = "${file("${path.cwd}${var.relative_key_path}")}"
        }
   }

   provisioner "remote-exec" {
       inline = [
         "chmod +x /tmp/rsyslog_omkafka.sh",
         "/tmp/rsyslog_omkafka.sh"
       ]

       connection {
            type = "ssh"
            user = "${var.user}"
            private_key = "${file("${path.cwd}${var.relative_key_path}")}"
        }
   }
}

output "public_ip" {
  value = "${aws_instance.rsyslog_omkafka.public_ip}"
}
