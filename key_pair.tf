resource "aws_key_pair" "deployer_key" {
  key_name   = "${var.resource_type}-${var.environment}-${var.customer}-key"
  public_key = file("~/.ssh/id_ed25519.pub")

  tags = {
    Name = "${var.resource_type}-${var.environment}-${var.customer}-key"
    environment = var.environment
    customer    = var.customer
    resource_type = var.resource_type
  }
}