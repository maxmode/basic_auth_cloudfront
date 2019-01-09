
## Introduction
Terraform module to protect website with Basic HTTP Auth.

Module will generate an Edge Lambda function, that can be associated with
 "viewer-request" event of CloudFront distribution

## Usage

### Preconditions
1. Your website should serve traffic via CloudFront
1. The CloudFront distribution should be created and managed via terraform.


### Include it as a module from github

Create file index.tf with your configuration:
```

provider "aws" {
  version = "~> 1.12"
  // Region "us-east-1" will establish Cloudfront <==> S3 integration faster
  region = "us-east-1"
  access_key = "XXXXXX"
  secret_key = "XXXXXXXXXXX"
}
provider "archive" {
  version = "~> 1.0"
}

module "basic_auth_cloudfront" {
  source       = "github.com/maxmode/basic_auth_cloudfront"
  
  // Username and password for basic http auth
  username = "XXX"
  password = "XXX"
  
  // Domain, for which basic auth should be set
  domain = "example.com"
}

// Add a lambda function during difinition of cloudfront distribution
resource "aws_cloudfront_distribution" "example" {
  # ... other configuration ...

  # lambda_function_association is also supported by default_cache_behavior
  ordered_cache_behavior {
    # ... other configuration ...

    lambda_function_association {
      event_type   = "viewer-request"
      lambda_arn   = "${module.basic_auth_cloudfront.lambda_viewer_request}"
      include_body = false
    }
  }
}
```

### Execute terraform
 
 - Run `terraform init`
 - Run `terraform apply`
 - Wait 5..30 min, until Cloudfront synchronizes configuration across all endpoints

### How to check?

Go to website https://example.com, browser should ask you for 
Basic HTTP authorization - username and password. After entering 
correct values you should have access to the website

