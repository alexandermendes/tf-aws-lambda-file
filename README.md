# Terraform AWS Zipped Lambda File Module

A Terraform module to create AWS Lambda resources from file.

## Usage

For a function `my-function.py` placed in the `functions` directory in the root
of the repository.

```terraform
module "lambda" {
  source  = "git::https://github.com/alexandermendes/tf-aws-lambda-file.git?ref=tags/v1.0.0"
  name    = "my-function"
  dir     = "functions"
  ext     = "py"
  runtime = "python3.7"
  handler = "lambda_handler"
}
```

**Note that the source reference above is just an example, in most cases you
should update it to the [latest tag](https://github.com/alexandermendes/tf-aws-lambda-file/tags).**

For additional variables and outputs see [variables.tf](./variables.tf) and
[output.tf](./output.tf), respectively.
