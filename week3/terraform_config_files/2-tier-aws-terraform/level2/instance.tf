module "instances" {

  source = "../modules/instances"
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name

}













# resource "aws_instance" "web_instance" {
#   ami                         = "ami-0b08bfc6ff7069aff" # Specify the appropriate AMI ID for your desired operating system and region
#   instance_type               = "t2.micro"              # Update with the desired instance type
#   user_data                   = file("user_data_web.sh")
#   subnet_id                   = data.terraform_remote_state.level1.outputs.public_subnet_ids
#   key_name                    = "aws-ec2" # Update with your key pair name for SSH access
#   associate_public_ip_address = true      # Assign a public IP address to the instance
#   vpc_security_group_ids      = [aws_security_group.web_security_group.id]



#   tags = {
#     Name = "Web-Server Instance"
#   }
# }



# resource "aws_instance" "database_instance" {
#   ami           = "ami-0b08bfc6ff7069aff" # Specify the appropriate AMI ID for your desired operating system and region
#   instance_type = "t2.micro"              # Update with the desired instance type

#   subnet_id                   = data.terraform_remote_state.level1.outputs.private_subnet_ids
#   key_name                    = "aws-ec2" # Update with your key pair name for SSH access
#   associate_public_ip_address = false     # Assign a public IP address to the instance
#   vpc_security_group_ids      = [aws_security_group.database_security_group.id]

#   user_data = <<-EOF

#     # #!/bin/bash
#     # # Install Node.js
    
#     # sudo yum install -y gcc-c++ make 
#     # sudo curl -sL https://rpm.nodesource.com/setup_18.x | sudo -E bash -
#     # sudo yum install -y nodejs 

#     EOF

#   tags = {
#     Name = "Database-Server Instance"
#   }
# }
