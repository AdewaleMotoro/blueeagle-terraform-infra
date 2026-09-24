# modules/ec2/main.tf
#
# Creates an EC2 instance inside an existing VPC, with:
#   - A security group allowing SSH (from your IP) and HTTP (public)
#   - An Elastic IP for a static public address
#   - Attached IAM instance profile (for S3 access, etc.)

# ---
# Security group — the instance's firewall.
# ---
resource "aws_security_group" "app" {
  name        = "${var.name_prefix}-ec2-sg"
  description = "Security group for ${var.name_prefix} EC2 instance"
  vpc_id      = var.vpc_id

  # SSH — restricted to a specific CIDR (your IP)
  ingress {
    description = "SSH from allowed CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  # HTTP — open to the world (for web apps)
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS — open to the world
  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All outbound traffic allowed (for apt, docker pull, etc.)
  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name  = "${var.name_prefix}-ec2-sg"
    Owner = var.trainee_name
  })
}

# ---
# The EC2 instance itself.
# ---
resource "aws_instance" "app" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.app.id]
  key_name               = var.key_name
  iam_instance_profile   = var.instance_profile_name

  # Auto-assign public IP (needed since we want public access)
  associate_public_ip_address = true

  # Root volume — 8 GB gp3 (cheap, fast)
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 8
    delete_on_termination = true
    encrypted             = true
  }

  tags = merge(var.tags, {
    Name  = "${var.name_prefix}-ec2"
    Owner = var.trainee_name
  })
}

# ---
# Elastic IP — static public address that survives reboots.
# ---
resource "aws_eip" "app" {
  instance = aws_instance.app.id
  domain   = "vpc"

  tags = merge(var.tags, {
    Name  = "${var.name_prefix}-eip"
    Owner = var.trainee_name
  })
}