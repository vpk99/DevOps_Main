resource "aws_lb" "preschool" {
  name               = "preschool"
  internal           = false
  load_balancer_type = "network"
  subnets            = module.vpc.public_subnets
  security_groups    = [module.security_group.security_group_id]
  depends_on         = [module.vpc, module.security_group]

}

resource "aws_lb_listener" "tcp" {
  load_balancer_arn = aws_lb.preschool.arn
  port              = local.http
  protocol          = local.TCP
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.preschool-tg.arn
  }
  depends_on = [aws_lb_target_group.preschool-tg]
}

resource "aws_lb_target_group" "preschool-tg" {
  name     = "preschool-tg"
  port     = local.http
  protocol = local.TCP
  vpc_id   = module.vpc.vpc_id

  depends_on = [module.vpc]
}