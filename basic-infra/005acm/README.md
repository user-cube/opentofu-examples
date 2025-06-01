# ACM Certificate with Cloudflare DNS (OpenTofu)

This example provisions an AWS ACM certificate for a custom domain (e.g., `example.com`) and validates it using DNS records managed through Cloudflare.

---

## 📦 Components

- **AWS ACM** – creates a DNS-validated certificate
- **Cloudflare** – creates validation CNAME records
- **OpenTofu** – IaC engine (Terraform-compatible)

---

## 🚀 Prerequisites

- A registered domain (e.g., from Namecheap, GoDaddy, etc.)
- Cloudflare API token with DNS edit permissions
- AWS credentials set via environment or profile
- OpenTofu installed (`brew install opentofu` or see [opentofu.org](https://opentofu.org))

---

## 🛠 Usage (Two-Step Apply)

Because AWS only provides the DNS validation records **after** the certificate is created, we apply in two steps:

### 1️⃣ Create the ACM certificate

```bash
tofu apply -target=module.acm
```

### 2️⃣ Create Cloudflare DNS validation records

```bash
tofu apply
```

ACM will detect the DNS records and issue the certificate shortly after.

---

## 📁 Project Structure

```
.
├── main.tf                        # Root config
├── variables.tf                  # Input variables
├── modules/
│   └── cloudflare-acm-validation/
│       ├── main.tf               # Cloudflare record creation
│       └── variables.tf
```

---

## 🧪 Example Variable File

Create a `terraform.tfvars`:

```hcl
domain_name           = "example.com"
san_names             = ["*.example.com"]
cloudflare_zone_id    = "your-zone-id"
cloudflare_api_token  = "your-api-token"
region                = "us-east-1"
```

---

## ✅ Notes

- DNS records must **not be proxied** (`proxied = false`) in Cloudflare for validation to succeed.
- Certificates are issued in `us-east-1` for use with CloudFront.

---

## 🧹 Cleanup

To destroy everything:

```bash
tofu destroy
```
