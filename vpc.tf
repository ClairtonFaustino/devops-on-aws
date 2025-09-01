resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    
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