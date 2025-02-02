resource "aws_lb" "james_lb" {
  name            = "james-loadbalancer"
  subnets         = var.public_subnets
  security_groups = var.public_security_groups
  idle_timeout    = 900
}

/*
Avoid naming conflicts during recreate/redeploy:
When you destroy and recreate resources, AWS keeps the old name in a "cooling period"
Without random suffixes, you might get errors like "name already exists" when redeploying
*/

resource "aws_lb_target_group" "james_target_group" {
  name     = "james-lb-tg-${substr(uuid(), 0, 4)}"
  port     = var.tg_port
  protocol = var.tg_protocol
  vpc_id   = var.vpc_id
  lifecycle {
    ignore_changes        = [name]
    create_before_destroy = true
    // when set to false, the destruction will be halted because:
    // when we change the port, the target group will be destroyed, 
    // and the listener has no where to route the traffic until the new target group is created
    // but listener cannot live without target group, the deletion of the target group will get halted due to AWS's own validation
    // we use create_before_destroy = true to make sure there must be an existing target group assignable to the listener
  }
  health_check {
    healthy_threshold   = var.lb_healthy_threshold
    unhealthy_threshold = var.lb_unhealthy_threshold
    timeout             = var.lb_timeout
    interval            = var.lb_interval
  }
}


resource "aws_lb_listener" "james_lb_listener" {
  load_balancer_arn = aws_lb.james_lb.arn
  port              = var.listener_port
  protocol          = var.listener_portocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.james_target_group.arn
  }

}
