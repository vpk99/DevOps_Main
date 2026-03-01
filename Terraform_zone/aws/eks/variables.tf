variable "role_name" {
  type = string
  description = "role for eks cluster"
  default = "eks_cluster_role"
}

variable "cluster_name" {
  type = string
  default = "main"
}

variable "node_group" {
  type = map(object({
    node_group_name = string
    instance_type = list(string)
    capacity_type = string
    scaling_info = object({
      desired_size = number
      max_size = number
      min_size = number
    })

  }))
}