terraform {
    backend "s3" {
        bucket = "itss-devops-ojt-tfstate"
        key    = "tfstate-devops-ojt-cajayon"
        region = "ap-southeast-1"
    }
}