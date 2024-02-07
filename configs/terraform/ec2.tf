# resource "aws_key_pair" "terraform_ec2_key" {
# 	key_name = "terraform_ec2_key"
# 	public_key = "${file("terraform_ec2_key.pub")}"
# }

resource "aws_instance" "ansible_master" {
	ami = "ami-0c7217cdde317cfec"
	instance_type = "t2.micro"
	key_name = "c-sa"
	subnet_id = "subnet-088b9604b70139d4a"
	vpc_security_group_ids = ["sg-01c5b81a67fb0a380"]
	tags = {
		Name = "ansible-master-server"
	}

	connection {
		type        = "ssh"
		user        = "ubuntu"
		private_key = "${file("c-sa.pem")}"
		host        = "${self.public_ip}"
	}

	provisioner "remote-exec" {
		inline = [
			"sudo apt update",
			"sudo apt install software-properties-common -y",
			"sudo add-apt-repository --yes --update ppa:ansible/ansible",
			"sudo apt install ansible -y",
			"sudo apt install git -y"
		]
	}
}

resource "aws_instance" "ansible_worker" {
	ami = "ami-0c7217cdde317cfec"
	instance_type = "t2.micro"
	key_name = "c-sa"
	subnet_id = "subnet-088b9604b70139d4a"
	vpc_security_group_ids = ["sg-01c5b81a67fb0a380"]
	tags = {
		Name = "ansible-worker-server"
	}

}