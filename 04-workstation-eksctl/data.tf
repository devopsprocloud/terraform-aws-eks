data "aws_ami" "rhel-9"{
    owners = ["973714476881"]
    most_recent = true

    filter {
        name = "name"
        values = ["RHEL-9-DevOps-Practice"]
    }

    filter {
        name = "root-device-type"
        values = ["ebs"]
    }   

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/public_subnet_ids"

}

data "aws_ssm_parameter" "workstation_sg_id" {
  name = "/${var.project_name}/${var.environment}/workstation_sg_id"

}