resource "aws_instance" "workstation" {
  ami           = data.aws_ami.rhel-9.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [local.workstation_sg_id]
  subnet_id = local.public_subnet_id

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  # Make sure workstation.sh starts with #!/bin/bash -xe
  user_data = file("workstation.sh")

  # Must be an instance profile, not just a role name
  iam_instance_profile = "terraform-EKS-admin"

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-workstation"
    }
  )
}
