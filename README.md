# Cyou.b - terraform-aws-staticsite

This Terraform project automates the setup of a secure and scalable static website hosting infrastructure on Amazon Web Services (AWS). It utilizes several AWS services to achieve this:

## Terraform Resources Used:

### 1. Amazon Certificate Manager (ACM)

**Resource:** `aws_acm_certificate.cert`

- **Purpose:** Creates an SSL/TLS certificate for the specified domain to enable secure HTTPS connections.

### 2. Amazon S3 Bucket

**Resources:** 
- `aws_s3_bucket.s3_bucket`
- `aws_s3_bucket_ownership_controls.s3_ownership`
- `aws_s3_bucket_public_access_block.block_public_access`

- **Purpose:** Configures an S3 bucket to store static files securely and efficiently. It enforces object ownership controls and blocks public access, ensuring data integrity and security.

### 3. CloudFront Distribution

**Resource:** `aws_cloudfront_distribution.s3_distribution`

- **Purpose:** Sets up a CloudFront distribution with the S3 bucket as its origin. This content delivery network (CDN) enhances website performance, provides caching capabilities, and ensures low-latency content delivery globally.

### 4. Route 53 DNS Records

**Resources:**
- `aws_route53_zone.public_zone`
- `aws_route53_record.www`
- `aws_route53_record.record_a`

- **Purpose:** Creates DNS records in Route 53 for the domain, enabling seamless mapping of the domain to the CloudFront distribution. It includes domain validation required by ACM and sets up an A record alias to the CloudFront distribution.

### 5. CloudFront Origin Access Control

**Resource:** `aws_cloudfront_origin_access_control.cloudfront_s3_oac`

- **Purpose:** Specifies access control settings for the CloudFront distribution, ensuring secure communication between CloudFront and the S3 bucket.

## Prerequisites:

- **AWS Account:** You need an AWS account to create and manage the infrastructure resources.
- **Terraform Installed:** Ensure Terraform is installed on your local machine.
- **AWS Credentials:** Configure your AWS access key and secret key for authentication.


## Usage

1. **Clone the Repository**

```bash
git clone https://github.com/cyou-b/terraform-staticsite.git
cd terraform-staticsite
```

2. **Configure main**

- Configure main.tf if want to configure a S3 bucket backend to store terraform config.

3. **Set Terraform Variables**

- Open `variables.tf` file and provide values for the following variables:
  - `aws_region`: AWS region where the infrastructure will be deployed (e.g., "us-east-1").
  - `bucket_name`: Unique name for the S3 bucket.
  - `domain`: Domain name for the website (e.g., "example.com").

4. **Initialize Terraform**

```bash
terraform init
```

5. **Review Terraform Plan**

```bash
terraform plan
```

6. **Apply Terraform Changes**

```bash
terraform apply
```

After apply changes, will be necessary add DNS nameservers to you domain 

7. **Cleanup (Optional)**

```bash
terraform destroy
```

## License
This project is licensed under the [License Name] License - see the [LICENSE.md](LICENSE.md) file for details.

---

**Note:** Ensure that you follow AWS best practices and security guidelines