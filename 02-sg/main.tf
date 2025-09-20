module "workstation_sg" {
  source = "git::https://github.com/devopsprocloud/terraform-sg-module.git?ref=main"
  sg_name = "eks-workstation"
  sg_description = "Securiy Group for EKS Workstation"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  project_name = var.project_name
  environment = var.environment
}

module "ingress_sg" {
  source = "git::https://github.com/devopsprocloud/terraform-sg-module.git?ref=main"
  sg_name = "ingress-controller"
  sg_description = "Securiy Group for Ingress Controller"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  project_name = var.project_name
  environment = var.environment
}

module "cluster_sg" {
  source = "git::https://github.com/devopsprocloud/terraform-sg-module.git?ref=main"
  sg_name = "eks-cluster"
  sg_description = "Securiy Group for EKS Cluster"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  project_name = var.project_name
  environment = var.environment
}

module "node_sg" {
  source = "git::https://github.com/devopsprocloud/terraform-sg-module.git?ref=main"
  sg_name = "eks-node"
  sg_description = "Securiy Group for EKS Nodes"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  project_name = var.project_name
  environment = var.environment
}

resource "aws_security_group_rule" "workstation_laptop" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.workstation_sg.sg_id
}


resource "aws_security_group_rule" "ingress_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.ingress_sg.sg_id
}

# Cluster is acepting all traffic from nodes on all ports
# resource "aws_security_group_rule" "cluster_node" {
#   security_group_id = module.cluster_sg.sg_id
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 65535
#   protocol          = "tcp"  
#   source_security_group_id = module.node_sg.sg_id
# }

resource "aws_security_group_rule" "cluster_node" {
  security_group_id = module.cluster_sg.sg_id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"  
  source_security_group_id = module.node_sg.sg_id
}

# Node is accepting traffic from master on all ports
# resource "aws_security_group_rule" "node_cluster" {
#   security_group_id = module.node_sg.sg_id
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 65535
#   protocol          = "tcp"  
#   source_security_group_id = module.cluster_sg.sg_id
# }

resource "aws_security_group_rule" "node_cluster" {
  security_group_id = module.node_sg.sg_id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"  
  source_security_group_id = module.cluster_sg.sg_id
}

resource "aws_security_group_rule" "cluster_workstation" {
  type              = "ingress"
  from_port        = 443
  to_port          = 443
  protocol         = "tcp"
  source_security_group_id = module.workstation_sg.sg_id
  security_group_id = module.cluster_sg.sg_id
}


# Nodes are accepting connections from Ingress Controller on ephemeral ports
# resource "aws_security_group_rule" "node_ingress" {
#   security_group_id = module.node_sg.sg_id
#   type              = "ingress"
#   from_port         = 30000
#   to_port           = 32767
#   protocol          = "tcp"  
#   source_security_group_id = module.ingress_sg.sg_id
# }

resource "aws_security_group_rule" "node_workstation" {
  type              = "ingress"
  from_port        = 22
  to_port          = 22
  protocol         = "tcp"
  source_security_group_id = module.workstation_sg.sg_id
  security_group_id = module.node_sg.sg_id
}


resource "aws_security_group_rule" "node_vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = ["10.0.0.0/16"]
  security_group_id = module.node_sg.sg_id
}

