output "arn" {
    description = <<-EOF
        description: Certificate manager arn
    EOF
    value = aws_acm_certificate.main.arn
}

output "id" {
    description = <<-EOF
        description: Certificate manager id
    EOF
    value = aws_acm_certificate.main.id
}

output "domain_name" {
    description = <<-EOF
        description: domain name for certificate
    EOF
    value = aws_acm_certificate.main.domain_name
}

output "status" {
    description = <<-EOF
        description: Certificate manager process status
    EOF
    value = aws_acm_certificate.main.status
}