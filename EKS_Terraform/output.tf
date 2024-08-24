output "cluster_id" {
  value = aws_eks_cluster.mihir.id
}

output "node_group_id" {
  value = aws_eks_node_group.mihir.id
}

output "vpc_id" {
  value = aws_vpc.mihir_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.mihir_subnet[*].id
}


