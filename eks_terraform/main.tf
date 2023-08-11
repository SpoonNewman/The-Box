module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "my-cluster"
  cluster_version = "1.27"

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = "vpc-07493c4ef33a2966e"
  subnet_ids               = ["subnet-0b7b0ca7f70b5d4fd", "subnet-08ad9a0639b24a1a1", "subnet-08797671cb04c4e6f"]
  control_plane_subnet_ids = ["subnet-0b7b0ca7f70b5d4fd", "subnet-08ad9a0639b24a1a1", "subnet-08797671cb04c4e6f"]

  eks_managed_node_group_defaults = {
    instance_types = ["t2.large"]
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 3
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
    project     = "The_Box"
    author      = "Spoon_Newman" 
  }
}
  # Self Managed Node Group(s)
#   self_managed_node_group_defaults = {
#     instance_type                          = "m6i.large"
#     update_launch_template_default_version = true
#     iam_role_additional_policies = {
#       AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#     }
#   }

#   self_managed_node_groups = {
#     one = {
#       name         = "mixed-1"
#       max_size     = 5
#       desired_size = 2

#       use_mixed_instances_policy = true
#       mixed_instances_policy = {
#         instances_distribution = {
#           on_demand_base_capacity                  = 0
#           on_demand_percentage_above_base_capacity = 10
#           spot_allocation_strategy                 = "capacity-optimized"
#         }

#         override = [
#           {
#             instance_type     = "m5.large"
#             weighted_capacity = "1"
#           },
#           {
#             instance_type     = "m6i.large"
#             weighted_capacity = "2"
#           },
#         ]
#       }
#     }
#   }

  # EKS Managed Node Group(s)
  # Fargate Profile(s)
#   fargate_profiles = {
#     default = {
#       name = "default"
#       selectors = [
#         {
#           namespace = "default"
#         }
#       ]
#     }
#   }

  # aws-auth configmap
#   manage_aws_auth_configmap = true

#   aws_auth_roles = [
#     {
#       rolearn  = "arn:aws:iam::66666666666:role/role1"
#       username = "role1"
#       groups   = ["system:masters"]
#     },
#   ]

#   aws_auth_users = [
#     {
#       userarn  = "arn:aws:iam::66666666666:user/user1"
#       username = "user1"
#       groups   = ["system:masters"]
#     },
#     {
#       userarn  = "arn:aws:iam::66666666666:user/user2"
#       username = "user2"
#       groups   = ["system:masters"]
#     },
#   ]

#   aws_auth_accounts = [
#     "777777777777",
#     "888888888888",
#   ]
