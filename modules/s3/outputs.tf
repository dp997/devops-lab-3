output "dataset_bucket" {
    value = aws_s3_bucket.dataset_bucket.id
}

output "lambda_bucket" {
    value = aws_s3_bucket.lambda_bucket.id
}