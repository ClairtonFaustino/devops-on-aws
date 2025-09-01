variable "region" {
    description = "default region for AWS projects"
    type        = string
}

variable "environment" {
    description = "Environment for the resources"
    type        = string
}

variable "customer" {
    description = "Customer name for the resources"
    type        = string
}

variable "resource_type" {
    description = "Resource type for the resources"
    type        = string
}

variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type        = string
}

variable "subnet_cidr" {
    description = "CIDR block for the Subnet"
    type        = string
}

variable "project" {
    description = "Project name"
    type        = string
}