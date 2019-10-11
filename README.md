# Terraform Zipped Lambda Module

A Terraform module to create AWS Lambda resources from file.

## Usage

For a function `my-function.py` placed in the `functions` directory in the root
of the repository.

```terraform
module "lambda" {
  source  = "git@github.com:alexandermendes/tf-zipped-lambda.git"
  name    = "my-function"
  dir     = "functions"
  runtime = "python3.7"
  handler = "lambda_handler"
}
```

