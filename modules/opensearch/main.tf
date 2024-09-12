resource "aws_opensearch_domain" "facial_recog_opensearch" {
  domain_name           = var.opensearch_domain_name
  engine_version  = var.opensearch_version
  cluster_config {
    instance_type = var.opensearch_instance_type
    instance_count = var.opensearch_instance_count
    multi_az_with_standby_enabled = var.multi_az_with_standby_enabled
  }
  ebs_options {
    ebs_enabled = true
    volume_size = var.opensearch_volume_size
  }
  domain_endpoint_options {
    enforce_https = true
  }
  encrypt_at_rest {
    enabled = true
  }
    node_to_node_encryption {
        enabled = true
    }
    advanced_security_options {
        enabled = true
        internal_user_database_enabled = true
        master_user_options {
            master_user_password = var.opensearch_master_user_password
            master_user_name = var.opensearch_master_user_name
        }
    }
  
  
  access_policies = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "es:*",
        Resource  = "*"
      }
    ]
  })
}