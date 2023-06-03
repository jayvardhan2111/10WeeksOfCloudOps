
resource "aws_instance" "web_instance" {
  count = length(data.terraform_remote_state.level1.outputs.public_subnet_ids)
  ami                         = var.ami_id
  instance_type               = var.instance_type
  user_data                   = file("user_data_web.sh")
  subnet_id                   = data.terraform_remote_state.level1.outputs.public_subnet_ids[count.index]
  key_name                    = "aws-ec2"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.web_security_group.id]



  tags = {
    Name = "Web-Server Instance"
  }
}



resource "aws_instance" "database_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  user_data                   = file("user_data_data.sh")
  subnet_id                   = data.terraform_remote_state.level1.outputs.private_subnet_ids
  key_name                    = "aws-ec2"
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.database_security_group.id]

  tags = {
    Name = "Database-Server Instance"
  }
}
