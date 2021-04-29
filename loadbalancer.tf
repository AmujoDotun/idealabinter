resource "aws_lb" "idealab" {
  name               = "idealab-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow-web.id]
  subnets            = [aws_subnet.newtechprod-subnet.id, aws_subnet.newtechprod-subnet2.id]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.idealablog.bucket
    prefix  = "idealab-lb"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}