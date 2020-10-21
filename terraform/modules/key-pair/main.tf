resource "aws_key_pair" "key_pair" {
  key_name = "${var.application}-${var.environment}-key"
  public_key = var.ssh_public_key
}
