resource "aws_instance" "test-server" {
    ami                    = "ami-03978d951b279ec0b"
    instance_type          = "t3.small"
    key_name               = "bookmyshow"
    vpc_security_group_ids = ["sg-0f397573565c4e8eb"]

    connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = file("./bookmyshow.pem")
        host        = self.public_ip
    }

    provisioner "remote-exec" {
        inline = ["echo 'wait to start the instance' "]
    }

    tags = {
        Name = "test-server"
    }

    provisioner "local-exec" {
        # This writes the IP to the inventory file
        command = "echo ${aws_instance.test-server.public_ip} > inventory"
    }

    # --------------------------------------------------------------------------
    # CRITICAL FIX: Explicitly specify the inventory and the private key for Ansible
    # --------------------------------------------------------------------------
    provisioner "local-exec" {
        command = "ansible-playbook -i inventory --private-key bookmyshow.pem /var/lib/jenkins/workspace/zomatoapp/terraformfiles/ansiblebook.yml"
    }
}
