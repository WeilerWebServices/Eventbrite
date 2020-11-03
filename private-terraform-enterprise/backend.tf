terraform {
  backend "s3" {
    bucket         = "ebdomains-prod-tlz-bootstrap-state-064568058039"
    dynamodb_table = "ebdomains-prod-tlz-bootstrap-state-064568058039-lock"
    key            = "tlz-ptfe.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
