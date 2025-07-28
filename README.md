

# Terraform Project: Static Website on Google Cloud

This Terraform project deploys a static website to Google Cloud Storage, configures a load balancer, sets up CDN, and manages DNS records.

## Overview

The project automates the following:

*   Creation of Google Cloud Storage buckets for the website and an error page.
*   Uploading static content (HTML files) to the buckets.
*   Configuration of a Google Cloud Load Balancer to serve the website.
*   Enabling CDN for the error page.
*   Setting up DNS records to point to the load balancer's IP address.

## Prerequisites

Before you begin, ensure you have the following:

*   A Google Cloud Platform (GCP) account.
*   The Google Cloud SDK (`gcloud`) installed and configured.
*   Terraform installed.
*   A registered domain name (e.g., `yasaman-shirdast.com`).

## Getting Started

1.  **Clone the repository:**

    ```bash
    git clone <your-repository-url>
    cd terraform-01/infra
    ```

2.  **Configure Terraform:**

    *   Initialize Terraform:

        ```bash
        terraform init
        ```

    *   Authenticate with Google Cloud:

        ```bash
        gcloud auth application-default login
        ```

3.  **Modify Variables:**

    *   Review the `main.tf` file and adjust the following variables as needed:
        *   `google_storage_bucket.website.name`:  Ensure the bucket name is globally unique. Consider appending a project ID or unique identifier.
        *   `google_dns_managed_zone.yasaman-shirdast.dns_name`: Replace `"yasaman-shirdast.com."` with your actual domain name.
    *   Review and update the variables configured in terraform.tfvars

4.  **Apply the Configuration:**

    ```bash
    terraform apply
    ```

    *   Review the plan and confirm the changes by typing `yes`.

5.  **Get the DNS Records**

    After Terraform apply is complete, retrieve the DNS records:

    ```bash
    terraform output
    ```

    *   Update your domain's DNS records with the provided values.  This usually involves adding an `A` record pointing your domain to the load balancer's IP address.

## Important Considerations

*   **Bucket Names:** Google Cloud Storage bucket names must be globally unique.
*   **Public Access:** The `google_storage_object_access_control` resource makes the `index.html` object publicly accessible. Ensure this is intentional. If you only want the website accessible via the load balancer, remove this resource.
*   **Error Handling:** The project includes an error page, but the load balancer configuration might need to be updated to properly redirect to it when errors occur.
*   **CDN**: CDN is enabled, set the correct TTL to prevent browser cache issues.

## Cleanup

To destroy the infrastructure created by Terraform:

```bash
terraform destroy
```

## Author

Yasaman Shirdast
