output "load_balancer_dns" {
  description = "DNS name of the load balancer"
  value       = aws_lb.lab_load_balancer.dns_name
}

output "load_balancer_zone_id" {
  description = "Zone ID of the load balancer"
  value       = aws_lb.lab_load_balancer.zone_id
}

output "red_instance_id" {
  description = "Instance ID of the red server"
  value       = aws_instance.red_instance.id
}

output "red_instance_public_ip" {
  description = "Public IP of the red instance"
  value       = aws_instance.red_instance.public_ip
}

output "blue_instance_id" {
  description = "Instance ID of the blue server"
  value       = aws_instance.blue_instance.id
}

output "blue_instance_public_ip" {
  description = "Public IP of the blue instance"
  value       = aws_instance.blue_instance.public_ip
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.website_bucket.id
}

output "website_urls" {
  description = "Website URLs for testing"
  value = {
    load_balancer  = "http://${aws_lb.lab_load_balancer.dns_name}"
    apex_domain    = "http://${var.domain_name}"
    www_domain     = "http://www.${var.domain_name}"
    red_subdomain  = "http://red.${var.domain_name}"
    blue_subdomain = "http://blue.${var.domain_name}"
    red_path       = "http://${aws_lb.lab_load_balancer.dns_name}/red"
    blue_path      = "http://${aws_lb.lab_load_balancer.dns_name}/blue"
  }
}

output "target_groups" {
  description = "Target group ARNs"
  value = {
    red_target_group  = aws_lb_target_group.red_tg.arn
    blue_target_group = aws_lb_target_group.blue_tg.arn
  }
}

output "security_groups" {
  description = "Security group IDs"
  value = {
    website_sg = aws_security_group.website_sg.id
    alb_sg     = aws_security_group.alb_sg.id
  }
}