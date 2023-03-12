module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 18.28.0"

  cluster_name    = var.cluster_name
  # cluster_version = var.cluster_version
  subnet_ids      = [aws_subnet.prod1-subnet.id, aws_subnet.prod2-subnet.id]
  vpc_id          = aws_vpc.prod-vpc.id


  eks_managed_node_group_defaults = {
    ami_type       = var.worker_group_ami_type
    instance_types = var.worker_group_instance_type

    attach_cluster_primary_security_group = false
    vpc_security_group_ids                = [aws_security_group.allow-web-traffic.id]
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = var.autoscaling_group_min_size
      max_size     = var.autoscaling_group_max_size
      desired_size = var.autoscaling_group_desired_capacity

      instance_types = var.worker_group_instance_type
      capacity_type  = var.worker_group_capacity_type
      labels = {
        Environment = var.worker_group_environment
      }
    }
  }
}

### to connect to cluster run 'aws eks --region <region-name> update-kubeconfig --name <cluster_name>' ###