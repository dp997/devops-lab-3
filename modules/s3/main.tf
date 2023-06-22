#````````````
#Buckets for lambda provisioning
#````````````

resource "aws_s3_bucket" "lambda_bucket" {
    bucket = "dpierzga-${var.unique_id}-lambda"

    tags = {
        Name = "Lambda bucket"
    }
}

resource "aws_s3_bucket" "lambda_results_bucket" {
    bucket = "dpierzga-${var.unique_id}-results"

    tags = {
        Name = "Lambda results bucket"
    }
}

resource "aws_s3_bucket" "dataset_bucket" {
    bucket = "dpierzga-${var.unique_id}-datasets"

    tags = {
        Name = "Dataset bucket"
    }
}

resource "aws_s3_object" "datasets" {
    for_each = fileset("${path.root}/", "*.csv")

    bucket = aws_s3_bucket.dataset_bucket.id

    key = each.value
    source = "${path.root}/${each.value}"
    etag = filemd5("${path.root}/${each.value}")
}

resource "aws_s3_object" "lambda_layers" {
    bucket = aws_s3_bucket.lambda_bucket.id

    key = "lambda_layer.zip"
    source = "${path.root}/lambda_layer.zip"
}

resource "aws_s3_object" "lambda_function" {
    bucket = aws_s3_bucket.lambda_bucket.id

    key = "lambda_function.zip"
    source = "${path.root}/lambda_function.zip"
}