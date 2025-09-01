resource "aws_instance" "srv_app_prod_1" {
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.app_secgroup.id]
  subnet_id              = aws_subnet.main.id
  ami                    = data.aws_ami.ubuntu.id
  key_name               = aws_key_pair.deployer_key.key_name

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt upgrade -y
              curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --disable traefik" sh
              mkdir -p ~/.kube
              sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
              sudo chown $USER:$USER ~/.kube/config
              EOF

  tags = {
    Name          = "${var.resource_type}-${var.environment}-${var.customer}"
    environment   = var.environment
    customer      = var.customer
    resource_type = var.resource_type
  }
}

resource "aws_security_group" "app_secgroup" {
  name        = "app_secgroup"
  description = "Security Group para os recursos"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name        = "${var.resource_type}-${var.environment}-${var.customer}-sg"
    environment = var.environment
    customer    = var.customer
    project     = var.project
  }
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

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.app_secgroup.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1

}
