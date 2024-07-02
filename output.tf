#Outputing DNS name of Aplication Load Balancer
output "alb_dns_name" {
  value       = "URL: ${aws_lb.application-lb-web.dns_name}"
  description = "The DNS name of the ALB"
}

