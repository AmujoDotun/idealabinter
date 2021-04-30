




resource "aws_lb" "idealab" {
  name               = "idealab-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow-web.id]
  subnets            = [aws_subnet.newtechprod-subnet.id, aws_subnet.newtechprod-subnet2.id]

  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.idealablog.bucket
    prefix  = "idealab-lb"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "idea_tg" {
  name     = "idealab-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.newtechprod-vpc.id
}

resource "aws_lb_target_group_attachment" "idealab_ga" {
  target_group_arn = aws_lb_target_group.idea_tg.arn
  target_id        = aws_instance.newtech-instance.id
  port             = 80
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.idealab.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.idea_tg.arn
  }
}