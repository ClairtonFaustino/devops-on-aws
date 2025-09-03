resource "aws_instance" "srv_app_prod_1" {
  instance_type          = "c7i-flex.large"
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
              export KUBECONFIG=~/.kube/config
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

