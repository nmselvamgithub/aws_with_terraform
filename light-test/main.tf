terraform {
  required_version = "~> 1.3"


  backend "s3" {
    bucket = "zremotestate"
    key = "state-lock/terraform.tfstate"
    region = "ap-northeast-1"
    dynamodb_table = "z-statelock"
}
}

#sleep for 4 min
resource "time_sleep" "sleeper" {
    create_duration = "120s"
  
}