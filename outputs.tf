output "alb_dns_name" {
  description = "DNS del ALB"
  value       = aws_lb.AC2-alb.dns_name
}
