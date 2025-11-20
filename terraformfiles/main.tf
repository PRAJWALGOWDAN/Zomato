resource "aws_instance" "test-server" {
  ami = "ami-0fa3fe0fa7920f68e
  instance_type = "t3.small"
  key_name = "bookmyshow"
  vpc_security_group_ids = ["sg-038934792fd6e7c3f"]
  connection {
     type = "ssh"
     user = "ec2-user"
     private_key = file("./bookmyshow.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/zomatoapp/terraformfiles/ansiblebook.yml"
     }
  }
