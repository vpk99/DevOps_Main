#creating_vpc

module "vpc" {
    source = "../modules/vpc"
    network_info = {
    name = "primary-network"
    cidr = "10.0.0.0/16"
  }
  public_subnets = [{
    name       = "web"
    az         = "us-east-1a"
    cidr_block = "10.0.0.0/24"
  }]
  private_subnets = [{
    name       = "data1"
    az         = "us-east-1b"
    cidr_block = "10.0.1.0/24"
    }, {
    name       = "data2"
    az         = "us-east-1c"
    cidr_block = "10.0.2.0/24"
  }]
  
}

#Creating security group

module "security_group" {
  source = "../modules/security_group"
security_group_info = {
    name        = "web-sg"
    description = "web security group"
    vpc_id      = module.vpc.vpc_id
    inbound_rules = [{
      cidr        = "0.0.0.0/0"
      from_port   = 80
      ip_protocol = "tcp"
      to_port     = 80
      description = "open http"
      }, {
      cidr        = "0.0.0.0/0"
      from_port   = 22
      ip_protocol = "tcp"
      to_port     = 22
      description = "open ssh"
    }]
    outbound_rules   = []
    allow_all_egress = true
  }
  depends_on = [module.vpc]

}



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
  name = "project_eks_cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  vpc_config {
    subnet_ids = module.vpc.public_subnets.id
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
  role = aws_iam_role.worker_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
 
 depends_on = [ aws_iam_role.worker_node_role ]

}

resource "aws_iam_role_policy_attachment" "cni" {
  role = aws_iam_role.worker_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"

  depends_on = [ aws_iam_role.worker_node_role ]
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role = aws_iam_role.worker_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

  depends_on = [ aws_iam_role.worker_node_role ]
}

# create NOde group

resource "aws_eks_node_group" "name" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  node_group_name = "project_node_group"
  node_role_arn = aws_iam_role.worker_node_role.arn
  subnet_ids = module.vpc.public_subnets.id
  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  instance_types = ["t2.medium"]

  depends_on = [ module.vpc, aws_iam_role.eks_cluster_role, 
  aws_eks_cluster.eks_cluster, 
  aws_iam_role.worker_node_role, 
  aws_iam_role_policy_attachment.attach_policy_for_eks
  ,aws_iam_role_policy_attachment.cni,
  aws_iam_role_policy_attachment.ecr,
  ]
}



