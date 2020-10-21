# Configure the Providers
provider "aws" {
  region = var.region
}

# note: variables are not allowed in the backend block
terraform {
  backend "s3" {
    bucket  = "test-terraform-states"
    key     = "state.tfstate"
    region  = "us-west-2"
  }
}