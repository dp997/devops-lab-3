resource "aws_lambda_function" "pytest" {
    package_type = "Image"
    image_uri = "${var.lambda_function_ecr}:latest"
    function_name = "pytest"
    role = var.lambda_role
    memory_size = "512"
    image_config {
      command = ["lambda_function.lambda_handler"]
    }
    environment {
      variables = {
        DBHOSTNAME = var.db_hostname
        DBPORT = var.db_port
        DBUSERNAME = var.db_username
        DBNAME = var.db_name
        DATASET_BUCKET = var.dataset_bucket
      }
    }
    timeout = 20
    vpc_config {
      subnet_ids = [var.private_subnet1, var.private_subnet2]
      security_group_ids = [var.backend_sg]
    }
}

resource "aws_lambda_invocation" "event1" {
  function_name = aws_lambda_function.pytest.function_name

  input = jsonencode({
    "dataset" = "Cars"
  })

}

