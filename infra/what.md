created a service account to run the terraform code.
the mentioned service account has the following roles to create the bucket and object:

Service Usage Consumer
Storage Admin
Storage Object Admin


role to create external application lb:
Compute Network Admin

https://cloud.google.com/load-balancing/docs/https/setup-global-ext-https-buckets#permissions



roles to create Cloud DNS:

https://cloud.google.com/dns/docs/access-control#dns.admin