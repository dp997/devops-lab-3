resource "aws_lambda_layer_version" "layer1" {
  layer_name = "PostgreSQL"
  s3_bucket = var.lambda_bucket
  s3_key = "lambda_layer.zip"
  compatible_runtimes = ["python3.10"]
}

resource "aws_lambda_function" "pytest" {
    filename = var.lambda_zip_path
    function_name = "pytest"
    role = var.lambda_role
    handler = "lambda_function.lambda_handler"
    runtime = "python3.10"
    environment {
      variables = {
        DBHOSTNAME = var.db_hostname
        DBPORT = var.db_port
        DBUSERNAME = var.db_username
        DBNAME = var.db_name
        DATASET_BUCKET = var.dataset_bucket
      }
    }
    layers = ["arn:aws:lambda:us-east-1:336392948345:layer:AWSSDKPandas-Python310:3", aws_lambda_layer_version.layer1.arn]
    timeout = 900
    vpc_config {
      subnet_ids = [var.private_subnet1]
      security_group_ids = [var.backend_sg]
    }
}