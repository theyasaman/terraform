#Bucket to store static website

resource "google_storage_bucket" "website"{
 name = "example_website_yasaman"
 location = "US"
}
# make the object public
/*
resource "google_storage_object_access_control" "public"{
 bucket = google_storage_bucket.website.name
 object = google_storage_bucket_object.index.name
 entity = "allUsers"
 role = "READER"
} */

# make the object private by not including the above resource


# Upload index.html to the bucket
resource "google_storage_bucket_object" "index"{
 name = "index.html"
 source = "./website/index.html"
 bucket = google_storage_bucket.website.name
}

# create a second bucket for fallout emoji
resource "google_storage_bucket" "fallout"{
 name = "example_website_yasaman_fallout"
 location = "US"
}
# upload the fallout emoji to the bucket
resource "google_storage_bucket_object" "fallout"{
 name = "fallout.html"
 source = "./website/fallout.html"
 bucket = google_storage_bucket.fallout.name
}


#load balancer
# Reserve IP address
resource "google_compute_global_address" "website_ip" {
  name = "website-ip"
}


# Create LB backend buckets
resource "google_compute_backend_bucket" "website" {
  name        = "website"
  description = "Contains its website"
  bucket_name = google_storage_bucket.website.name
}

resource "google_compute_backend_bucket" "fallout" {
  name        = "fallout"
  description = "Contains ascii emoji"
  bucket_name = google_storage_bucket.fallout.name
}


# Create HTTP target proxy
resource "google_compute_target_http_proxy" "default" {
  name    = "http-lb-proxy"
  url_map = google_compute_url_map.default.id
}

# Create forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "http-lb-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.website_ip.id
}


# Cloud DNS public managed zone

resource "google_dns_managed_zone" "yasaman-shirdast" {
  name        = "yasaman-shirdast"
  dns_name    = "yasaman-shirdast.com."
  description = "Example DNS zone"
  
}

resource "random_id" "rnd" {
  byte_length = 4
}

# I want to point it to the load balancer frontend IP

resource "google_dns_record_set" "a_record" {
  managed_zone = google_dns_managed_zone.yasaman-shirdast.name
  name = "${google_dns_managed_zone.yasaman-shirdast.dns_name}"
  type         = "A"
  rrdatas      = [google_compute_global_address.website_ip.address]
  ttl          = 300
}


# CDN will server content from a public bucket called error_page
resource "google_storage_bucket" "construction" {
 name = "yasaman-shirdats-error-page"
 location = "US"
}

resource "google_storage_bucket_object" "error_page_yasaman" {
  name    = "error_page_html"
  bucket  = google_storage_bucket.construction.name
  source = "./website/error.html"
}


resource "google_compute_backend_bucket" "error_page" {
  name        = "cat-backend-bucket"
  description = "simple html to tell that page is under construction"
  bucket_name = google_storage_bucket.construction.name
  enable_cdn  = true
  cdn_policy {
    cache_mode        = "CACHE_ALL_STATIC"
    client_ttl        = 3600
    default_ttl       = 3600
    max_ttl           = 86400
    negative_caching  = true
    serve_while_stale = 86400
  }
}




# Create url map
resource "google_compute_url_map" "default" {
  name = "http-lb"

  default_service = google_compute_backend_bucket.website.self_link

  host_rule {
    hosts        = ["/home"]
    path_matcher = "path-matcher-1"
  }

  path_matcher {
    name            = "path-matcher-1"
    default_service = google_compute_backend_bucket.website.id

    path_rule {
      paths   = ["fallout/*"]
      service = google_compute_backend_bucket.fallout.id
    }
  }
  

}
