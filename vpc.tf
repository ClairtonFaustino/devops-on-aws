resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support   = true
    
    tags = {
        Name = "${var.resource_type}-${var.environment}-${var.customer}-vpc"
        environment = var.environment
        customer    = var.customer
        project     = var.project
    }
}

resource "aws_subnet" "main" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.subnet_cidr
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.resource_type}-${var.environment}-${var.customer}-subnet"
        environment = var.environment
        customer    = var.customer
        project     = var.project
    }
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "${var.resource_type}-${var.environment}-${var.customer}-igw"
        environment = var.environment
        customer    = var.customer
        project     = var.project
    }
}

resource "aws_route_table" "main" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }
    tags = {
        Name = "${var.resource_type}-${var.environment}-${var.customer}-rt"
        environment = var.environment
        customer    = var.customer
        project     = var.project
    }
}

resource "aws_route_table_association" "a" {
    subnet_id      = aws_subnet.main.id
    route_table_id = aws_route_table.main.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.app_secgroup.id

  cidr_ipv4   = "${chomp(data.http.my_ip.response_body)}/32"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.app_secgroup.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.app_secgroup.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_k8s_api" {
  security_group_id = aws_security_group.app_secgroup.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 6443
  ip_protocol = "tcp"
  to_port     = 6443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.app_secgroup.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1

}
