provider "aws" {
    region = var.region
}

locals {
    tag_suffix          = "${var.project}_${var.stage}_${var.region_code}"
    validation_method   = upper(var.validation_method)
}

resource "null_resource" "validation" {
    lifecycle {
        precondition {
            condition = local.validation_method == "DNS" ? var.r53_zone_id != null ? true : false : true
            error_message = "[ERROR] var.r53_zone_id must be specified for DNS validation"
        }
        precondition {
            condition = local.validation_method == "EMAIL" ? var.validation_email != null ? true : false : true
            error_message = "[ERROR] var.validation_email must be specified for EMAIL validation"
        }
    }
}

resource "aws_acm_certificate" "main" {
    domain_name = var.domain_name
    subject_alternative_names = var.subject_alternative_names
    validation_method = local.validation_method
    tags = {Name = "cm_${replace(replace(var.domain_name,"*.",""),".","-")}_${local.tag_suffix}"}
    
    lifecycle {
        create_before_destroy = true
    }
    depends_on = [ null_resource.validation ]
}

resource "aws_route53_record" "main" {
    for_each = {
        for opt in aws_acm_certificate.main.domain_validation_options : opt.domain_name => {
            name = opt.resource_record_name
            record = opt.resource_record_value
            type = opt.resource_record_type
        }
    }
    zone_id = var.r53_zone_id
    name = each.value.name
    type = each.value.type
    records = [each.value.record]
    ttl = 60
    allow_overwrite = true
}

resource "aws_acm_certificate_validation" "main" {
    certificate_arn = aws_acm_certificate.main.arn
    validation_record_fqdns = [for record in aws_route53_record.main : record.fqdn]
}