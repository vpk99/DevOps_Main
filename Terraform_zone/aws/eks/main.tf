# Creating IAM Role for eks cluster

resource "aws_iam_role" "eks_cluster_role" {
  
  name = var.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
       "Action": [
                "sts:AssumeRole"
            ],
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "eks.amazonaws.com"
                ]
        }
      },
    ]
  })

}

resource "aws_iam_role_policy_attachment" "attach_policy_for_eks" {
role = aws_iam_role.eks_cluster_role.name
policy_arn = aws_iam_role.eks_cluster_role.arn

depends_on = [ aws_iam_role.eks_cluster_role ]

  
}

# Create EKS cluster

resource "aws_eks_cluster" "eks_cluster" {
  name = "main"
  role_arn = aws_iam_role.eks_cluster_role.arn
  vpc_config {
    subnet_ids = module.vpc.private_subnets.id
  }

  depends_on = [ aws_iam_role_policy_attachment.attach_policy_for_eks ]
}

#IAM role for node group

resource "aws_iam_role" "worker_node_role" {
  name = "worker_node_policy"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
       "Action": [
                "sts:AssumeRole"
            ],
            "Effect": "Allow",
            "Principal": {
                "Service": [
                     "ec2.amazonaws.com"

                ]
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "worker_node_policy" {
 for_each = toset([
  "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
  "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
  "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
])
  role = aws_iam_role.worker_node_role.name
  policy_arn = each.value

}



# create NOde group

resource "aws_eks_node_group" "name" {
  for_each = var.node_group
  cluster_name = aws_eks_cluster.eks_cluster.name
  node_group_name = each.key
  node_role_arn = aws_iam_role.worker_node_role.arn
  subnet_ids = module.vpc.private_subnets.id
  scaling_config {
    desired_size = each.value.scaling_info.desired_size
    max_size     = each.value.scalinf_info.max_size
    min_size     = each.value.scaling_info.min_size
  }
  instance_types = each.value.instance_type
  capacity_type = each.value.capacity_type

  depends_on = [ aws_iam_role_policy_attachment.worker_node_policy
  ]
}



