resource "aws_instance" "ansible_worker" {
	ami = "ami-0c7217cdde317cfec"
	instance_type = "t2.micro"
	key_name = "c-sa"
	subnet_id = "subnet-088b9604b70139d4a"
	vpc_security_group_ids = ["sg-01c5b81a67fb0a380"]
	tags = {
		Name = "ansible-worker-server"
	}

	connection {
		type        = "ssh"
		user        = "ubuntu"
		private_key = "${file("c-sa.pem")}"
		host        = "${self.public_ip}"
	}

	provisioner "remote-exec" {
		inline = [
			"sudo mkdir -p /var/www/html",
			"sudo chmod 777 /var/www/html"
		]
	}

	provisioner "file" {
			source      = "/home/ldev/Dev/Practica1SA/web/index.html"
			destination = "/var/www/html/index.html"  # Ruta de destino en la instancia EC2
	}

	provisioner "file" {
			source      = "/home/ldev/Dev/Practica1SA/web/fondo.jpg"
			destination = "/var/www/html/fondo.jpg"  # Ruta de destino en la instancia EC2
	}
}


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
			"mkdir -p /home/ubuntu/keys",  # Crea la ruta si no existe
			"sudo apt update",
			"sudo apt install software-properties-common -y",
			"sudo add-apt-repository --yes --update ppa:ansible/ansible",
			"sudo apt install ansible -y",
			"echo '[servers]' | sudo tee -a /etc/ansible/hosts",
			"echo 'server1 ansible_host=${aws_instance.ansible_worker.private_ip}' | sudo tee -a /etc/ansible/hosts",
			"echo '[all:vars]' | sudo tee -a /etc/ansible/hosts",
			"echo 'ansible_python_interpreter=/usr/bin/python3' | sudo tee -a /etc/ansible/hosts",
			"echo 'ansible_user=ubuntu' | sudo tee -a /etc/ansible/hosts",
			"echo 'ansible_ssh_private_key_file=/home/ubuntu/keys/Ansible.pem' | sudo tee -a /etc/ansible/hosts"
		]
	}

	provisioner "file" {
			source      = "/home/ldev/Dev/Practica1SA/configs/terraform/c-sa.pem"
			destination = "/home/ubuntu/keys/Ansible.pem"  # Ruta de destino en la instancia EC2
	}

	provisioner "remote-exec" {
		inline = [
			"sudo chmod 400 /home/ubuntu/keys/Ansible.pem"
		]
	}

	provisioner "file" {
			source      = "/home/ldev/Dev/Practica1SA/configs/ansible/playbook.yml"
			destination = "/home/ubuntu/playbook.yml"  # Ruta de destino en la instancia EC2
	}

	provisioner "remote-exec"{
		inline = [
			"export ANSIBLE_HOST_KEY_CHECKING=False",
			"ansible-playbook playbook.yml"
		]
	}
}
