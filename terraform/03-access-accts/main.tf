provider "aviatrix" {
  username                = "admin"
  controller_ip           = data.terraform_remote_state.aviatrix.outputs.aviatrix_controller_public_ip
  password                = data.terraform_remote_state.aviatrix.outputs.aviatrix_controller_password
  skip_version_validation = true
}

provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

data "terraform_remote_state" "aviatrix" {
  backend = "local"

  config = {
    path = "../02-aviatrix/terraform.tfstate"
  }
}

#data sources
data "aws_caller_identity" "current" {}



/*resource "aviatrix_account" "temp_acc_aws" {
  account_name       = "aws-demo"
  cloud_type         = 1
  aws_iam            = true
  aws_account_number = data.aws_caller_identity.current.account_id
  aws_access_key     = var.aws_access_key_id
  aws_secret_key     = var.aws_secret_access_key
}*/

resource "aviatrix_account" "temp_acc_aws" {
  account_name       = "aws-demo"
  cloud_type         = 1
  aws_account_number = data.aws_caller_identity.current.account_id
  aws_iam            = true
  aws_role_app       = data.terraform_remote_state.aviatrix.outputs.aviatrix-role-app-arn 
  aws_role_ec2       = data.terraform_remote_state.aviatrix.outputs.aviatrix-role-ec2-arn
}



