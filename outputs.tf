output "bastion_public_ip" {
    value = aws_instance.bastion.public_ip
}

output "private_ec2_1_private_ip" {
    value = aws_instance.private_ec2_1.private_ip
}

output "private_ec2_2_private_ip" {
    value = aws_instance.private_ec2_2.private_ip
}

output "public_subnet_1_id" {
    value = aws_subnet.public-1.id
}

output "public_subnet_2_id" {
    value = aws_subnet.public-2.id
}

output "private_subnet_1_id" {
    value = aws_subnet.private-1.id
}

output "private_subnet_2_id" {
    value = aws_subnet.private-2.id
}

output "aws_vpc_id" {
    value = aws_vpc.main.id
}

output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}

output "asg_name" {
  value = aws_autoscaling_group.app_asg.name
}

output "target_group_arn" {
  value = aws_lb_target_group.app_tg.arn
}