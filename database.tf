# s3 buckek


resource "aws_s3_bucket" "idealab" {
  bucket = "idealabprod-for-db"
  acl    = "private"

  tags = {
    Name        = "idealab bucket"
    Environment = "idealabprod"
  }
}

# for the load balancers logs

resource "aws_s3_bucket" "idealablog" {
  bucket = "idealabprodlog"
  acl    = "public-read-write"

  tags = {
    Name        = "idealab bucket log"
    Environment = "idealabprodlog"
  }
}


resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 2
  identifier         = "aurora-cluster-demo-${count.index}"
  cluster_identifier = aws_rds_cluster.idealabdb.id
  instance_class     = "db.t2.small"
  engine             = aws_rds_cluster.idealabdb.engine
  engine_version     = aws_rds_cluster.idealabdb.engine_version
}

resource "aws_rds_cluster" "idealabdb" {
  cluster_identifier = "aurora-cluster-demo"
  availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]
  database_name      = "idealab"
  master_username    = "admin"
  master_password    = "idealabadmin"
}


