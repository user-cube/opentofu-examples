# OpenTofu Examples

This repository contains a collection of OpenTofu (formerly Terraform) examples demonstrating various infrastructure patterns and best practices.

## Repository Structure

- `basic-infra/`: Contains basic infrastructure examples including VPC setup and networking configurations
  - `001state/`: State management and backend configuration
  - `002vpc/`: VPC and networking infrastructure
  - `003securitygroups/`: Security group configurations
  - `004s3/`: S3 bucket configurations
  - `005acm/`: ACM certificate configurations
  - `006cloudflare/`: Cloudflare configurations
  - `007secrets/`: AWS Secrets Manager configurations
  - `008rds/`: RDS database configurations
  - `009alb/`: Application Load Balancer configurations
  - `010ec2/`: EC2 instance configurations
- `modules/`: Reusable OpenTofu modules
- `playbooks/`: Ansible playbooks for infrastructure automation
- `docs/`: Documentation and diagrams

## Getting Started

1. Install OpenTofu (formerly Terraform) on your system
2. Configure your AWS credentials
3. Navigate to the desired example directory
4. Initialize the configuration:
   ```bash
   tofu init
   ```
5. Apply the configuration:
   ```bash
   tofu apply
   ```

## Prerequisites

- OpenTofu (formerly Terraform) >= 1.0.0
- AWS CLI configured with appropriate credentials
- Basic understanding of AWS services and infrastructure concepts

## Contributing

Feel free to submit issues and enhancement requests!
