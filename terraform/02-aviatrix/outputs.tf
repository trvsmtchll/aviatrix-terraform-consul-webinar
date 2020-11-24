
output "aviatrix-role-ec2-name" {
  value       = module.aviatrix-iam-roles.aviatrix-role-ec2-name
  description = "Aviatrix role name for EC2"
}

output "aviatrix-role-ec2-arn" {
  value       = module.aviatrix-iam-roles.aviatrix-role-ec2-arn
  description = "Aviatrix role ARN for EC2"
}

output "aviatrix-role-app-name" {
  value       = module.aviatrix-iam-roles.aviatrix-role-app-name
  description = "Aviatrix role name for application"
}

output "aviatrix-role-app-arn" {
  value       = module.aviatrix-iam-roles.aviatrix-role-app-arn
  description = "Aviatrix role ARN for application"
}

output "aviatrix-assume-role-policy-arn" {
  value       = module.aviatrix-iam-roles.aviatrix-assume-role-policy-arn
  description = "Aviatrix assume role policy ARN"
}

output "aviatrix-app-policy-arn" {
  value       = module.aviatrix-iam-roles.aviatrix-app-policy-arn
  description = "Aviatrix policy ARN for application"
}

output "aviatrix-role-ec2_profile-arn" {
  value       = module.aviatrix-iam-roles.aviatrix-role-ec2_profile-arn
  description = "Aviatrix role EC2 profile ARN for application"
}

output "aviatrix_controller_public_ip" {
  value = module.aviatrix-controller-build.public_ip
}

output "aviatrix_controller_private_ip" {
  value = module.aviatrix-controller-build.private_ip
}

output "aviatrix_controller_password" {
  value = random_string.password.result
}
