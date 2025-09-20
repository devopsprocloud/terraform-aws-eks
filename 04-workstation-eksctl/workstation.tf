resource "aws_instance" "bastion" {
  ami           = data.aws_ami.rhel-9.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [local.workstation_sg_id]
  subnet_id = local.public_subnet_id

  # need more for terraform
  root_block_device {
    volume_size = 30
    volume_type = "gp3" # or "gp2", depending on your preference
  }
  user_data = file("workstation.sh")
  iam_instance_profile = "EC2FullAccess"
  tags = merge(
    local.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-workstation"
    }
  )
}
