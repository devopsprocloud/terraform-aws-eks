module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "${var.project}-${var.environment}"
  kubernetes_version = "1.30"
  
  addons = {
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {}
    vpc-cni                = {
      before_compute = true
    }
    metrics-server= {}
  }


  # Optional
  endpoint_public_access                   = true
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = data.aws_ssm_parameter.vpc_id.value
  subnet_ids               = local.private_subnet_ids
  control_plane_subnet_ids = local.private_subnet_ids
  
  create_security_group = false
  security_group_id = local.cluster_sg_id

  create_node_security_group = false
  node_security_group_id     = local.node_sg_id

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    blue = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["m5.large"]
      min_size      = 2
      max_size      = 10
      desired_size  = 2
      capacity_type = "SPOT"
      
      iam_role_additional_policies = {
        AmazonEBS = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        AmazonEKSLoad = "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy"
        AmazonEFS = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
    }
    # green = {
    #   ami_type       = "AL2023_x86_64_STANDARD"
    #   instance_types = ["m5.large"]
    #   min_size      = 2
    #   max_size      = 10
    #   desired_size  = 2
    #   capacity_type = "SPOT"
      
    #   iam_role_additional_policies = {
    #     AmazonEBS = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    #     AmazonEKSLoad = "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy"
    #     AmazonEFS = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
    # }
  }
}
}