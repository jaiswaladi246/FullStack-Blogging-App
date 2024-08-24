provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "mihir_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "mihir-vpc"
  }
}

resource "aws_subnet" "mihir_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.mihir_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.mihir_vpc.cidr_block, 8, count.index)
  availability_zone       = element(["us-east-1a", "us-east-1b"], count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "mihir-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "mihir_igw" {
  vpc_id = aws_vpc.mihir_vpc.id

  tags = {
    Name = "mihir-igw"
  }
}

resource "aws_route_table" "mihir_route_table" {
  vpc_id = aws_vpc.mihir_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mihir_igw.id
  }

  tags = {
    Name = "mihir-route-table"
  }
}

resource "aws_route_table_association" "a" {
  count          = 2
  subnet_id      = aws_subnet.mihir_subnet[count.index].id
  route_table_id = aws_route_table.mihir_route_table.id
}

resource "aws_security_group" "mihir_cluster_sg" {
  vpc_id = aws_vpc.mihir_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mihir-cluster-sg"
  }
}

resource "aws_security_group" "mihir_node_sg" {
  vpc_id = aws_vpc.mihir_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mihir-node-sg"
  }
}

resource "aws_eks_cluster" "mihir" {
  name     = "mihir-cluster"
  role_arn = aws_iam_role.mihir_cluster_role.arn

  vpc_config {
    subnet_ids         = aws_subnet.mihir_subnet[*].id
    security_group_ids = [aws_security_group.mihir_cluster_sg.id]
  }
}

resource "aws_eks_node_group" "mihir" {
  cluster_name    = aws_eks_cluster.mihir.name
  node_group_name = "mihir-node-group"
  node_role_arn   = aws_iam_role.mihir_node_group_role.arn
  subnet_ids      = aws_subnet.mihir_subnet[*].id

  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 3
  }

  instance_types = ["t2.large"]

  remote_access {
    ec2_ssh_key               = "mihir"
    source_security_group_ids = [aws_security_group.mihir_node_sg.id]
  }

}

resource "aws_iam_role" "mihir_cluster_role" {
  name = "mihir-cluster-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "mihir_cluster_role_policy" {
  role       = aws_iam_role.mihir_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "mihir_node_group_role" {
  name = "mihir-node-group-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "mihir_node_group_role_policy" {
  role       = aws_iam_role.mihir_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "mihir_node_group_cni_policy" {
  role       = aws_iam_role.mihir_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "mihir_node_group_registry_policy" {
  role       = aws_iam_role.mihir_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
