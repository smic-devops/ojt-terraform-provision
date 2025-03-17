terraform {
    backend "s3" {
        bucket         = "itss-devops-ojt-tfstate"
        key            = "tfstate-devops-ojt-david"
        region         = "ap-southeast-1"
        }
    }