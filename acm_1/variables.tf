########## Project Definition ########## {
variable "project" {
    description = <<-EOF
        description: Project name or service name
        type: string
        required: yes
        example: project = "gitops"
    EOF
    type = string
}

variable "stage" {
    description = <<-EOF
        description: Service stage of project (dev, stg, prd etc)
        type: string
        required: yes
        example: stage = "dev"
    EOF
    type = string
}

variable "region" {
    description = <<-EOF
        description: '''Region name to create resources
                     refer to https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html#Concepts.RegionsAndAvailabilityZones.Regions'''
        type: string
        required: yes
        default: ap-northeast-2
        example: region = "ap-northeast-2"
    EOF
    type    = string
}

variable "region_code" {
    description = <<-EOF
        description: '''Country code for region
                     refer to https://countrycode.org'''
        type: string
        required: yes
        default: kr
        example: region_code = "kr"
    EOF
    type = string
}
########## Project Definition ########## }

########## Certificate Manager Definition ########## {
variable "domain_name" {
    description = <<-EOF
        description: Primary certificate domain name
        type: string
        required: yes
        example: domain_name = "*.example.com"
    EOF
    type = string
}

variable "subject_alternative_names" {
    description = <<-EOF
        description: Subject alternative domain names
        type: list(string)
        required: no
        default: []
        example: subject_alternative_names = ["ex, www.example.com"]
    EOF
    type = list(string)
    default = []
}

variable "validation_method" {
    description = <<-EOF
        description: '''Domain name validation method 
                     DNS, EMAIL or NONE is valid'''
        type: string
        required: yes
        example: validation_method = "DNS"
    EOF
    type = string
    validation {
        condition = contains(["DNS", "EMAIL"], upper(var.validation_method))
        error_message = "var.validation_method must be one of DNS, EMAIL"
    }
}

variable "r53_zone_id" {
    description = <<-EOF
        description: Route53 hosted zone ID for DNS validation method
        type: string
        required: no
        default: null
    EOF
    type = string
    default = null
}

variable "validation_email" {
    description = <<-EOF
        description: Email address for EMAIL validation method
        type: string
        required: no
        default: null
    EOF
    type = string
    default = null
}
########## Certificate Manager Definition ########## }