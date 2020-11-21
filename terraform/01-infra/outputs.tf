output "env" {
  value = random_string.env.result
}

output "private_key_pem" {
  value = tls_private_key.main.private_key_pem
}

output "ssh_key_public_key_openssh" {
  value = tls_private_key.main.public_key_openssh
}

output "aws_ssh_key_name" {
  value = aws_key_pair.demo.key_name
}

output "aws_shared_svcs_vpc" {
  value = module.vpc-shared-svcs.vpc_id
}

output "aws_shared_svcs_public_subnets" {
  value = module.vpc-shared-svcs.public_subnets
}
