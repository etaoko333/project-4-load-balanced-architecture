# Route 53 Records for subdomains
resource "aws_route53_record" "red_subdomain" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "red.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.lab_load_balancer.dns_name
    zone_id                = aws_lb.lab_load_balancer.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "blue_subdomain" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "blue.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.lab_load_balancer.dns_name
    zone_id                = aws_lb.lab_load_balancer.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "apex_domain" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.lab_load_balancer.dns_name
    zone_id                = aws_lb.lab_load_balancer.zone_id
    evaluate_target_health = true
  }
}

# Optional: WWW subdomain
resource "aws_route53_record" "www_subdomain" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.lab_load_balancer.dns_name
    zone_id                = aws_lb.lab_load_balancer.zone_id
    evaluate_target_health = true
  }
}