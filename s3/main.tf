resource "aws_s3_bucket" "my-bucket" {
  bucket = var.bucket_name

  tags = var.tags
  
  force_destroy = true

}
resource "aws_s3_bucket_website_configuration" "my-bucket" {
  bucket = aws_s3_bucket.my-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}
resource "aws_s3_bucket_versioning" "my-bucket" {
  bucket = aws_s3_bucket.my-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "my-bucket" {
  bucket = aws_s3_bucket.my-bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "my-bucket" {
  bucket = aws_s3_bucket.my-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "my-bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.my-bucket , aws_s3_bucket_public_access_block.my-bucket]
  

  bucket = aws_s3_bucket.my-bucket.id
  acl    = "public-read"
}
resource "aws_s3_bucket_policy" "my-bucket" {
  bucket = aws_s3_bucket.my-bucket.id

  policy = <<EOF
{
  "Id": "Policy1722082946018",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1722082940130",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::s3-454423/*",
      "Principal": "*"
    }
  ]
}
EOF
}



