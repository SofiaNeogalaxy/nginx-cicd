resource "aws_key_pair" "devopsrole_nginx_deployer" {
  key_name   = "nginx-keypair.pem"
  public_key = file("id_rsa.pub")
}

resource "aws_instance" "devopsrole_static_web" {
  ami                    = data.aws_ami.devopsrole_ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.devopsrole_nginx_deployer.key_name
  vpc_security_group_ids = [aws_security_group.devopsrole_http_sg.id, aws_security_group.devopsrole_custom_tcp_sg.id, aws_security_group.devopsrole_https_sg.id, aws_security_group.devopsrole_ssh_sg.id]
  subnet_id              = aws_subnet.devopsrole_public_subnet.id
  #user_data              = file("userdata.tpl")

  root_block_device {
    volume_size = 12
  }

  tags = {
    Name  = var.name
    Group = var.group
  }
}