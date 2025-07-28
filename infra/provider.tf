#GCP provider

provider "google"{

    #provides the credentials to authenticate to GCP
    credentials = file(var.gcp_svc_key)
    #pulls project and region defined in variables.tf
    project = var.gcp_project
    region = var.gcp_region
}


