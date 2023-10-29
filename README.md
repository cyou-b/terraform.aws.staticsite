# Cyou.b - terraform-staticsite

## Description
This Terraform project sets up a static file hosting infrastructure on AWS using S3, CloudFront, ACM (Amazon Certificate Manager), and Route 53. 
It creates an S3 bucket to store static files, configures CloudFront for content delivery, obtains and validates an SSL/TLS certificate using ACM, and sets up DNS records in Route 53.

## Prerequisites
- AWS Account
- Terraform Installed
- AWS Access Key and Secret Key Configured

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

## Terraform Resources

### Amazon Certificate Manager (ACM)
- **Certificate**: Creates an ACM certificate for the specified domain.

### CloudFront
- **Distribution**: Configures a CloudFront distribution with S3 as the origin. Handles caching, error responses, logging, and SSL/TLS settings.

### Route 53
- **Record Sets**: Creates DNS records for domain validation required by ACM and sets up an A record alias to the CloudFront distribution.

### S3 Bucket
- **Bucket**: Creates an S3 bucket for storing static files.
- **Bucket Policy**: Sets a public-read policy allowing objects to be retrieved by anyone.
- **Bucket ACL**: Configures ACL to allow public-read access.
- **Bucket Ownership Controls**: Configures object ownership for bucket owner preference.
- **Public Access Block**: Blocks public access at the bucket level.

## License
This project is licensed under the [License Name] License - see the [LICENSE.md](LICENSE.md) file for details.

---

**Note:** Ensure that you follow AWS best practices and security guidelines