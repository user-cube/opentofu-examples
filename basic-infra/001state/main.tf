module "state_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.15.1"

  bucket = "${data.aws_caller_identity.current.account_id}-${var.bucket_name}"

  versioning = {
    enabled = true
  }

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  tags = {
    description = "OpenTofu State Bucket"
    region      = var.region
    managed_by  = "OpenTofu"
    environment = var.env
    type        = "s3"
  }
}

resource "aws_dynamodb_table" "tofu_locks" {
  name         = "${data.aws_caller_identity.current.account_id}-${var.bucket_name}-opentofu-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    description = "OpenTofu State Lock Table"
    region      = var.region
    managed_by  = "OpenTofu"
    environment = var.env
    type        = "dynamodb"
  }
}