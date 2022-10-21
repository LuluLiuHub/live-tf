/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

provider "google" {
  project = var.project_id
  region  = var.region
}
terraform {
  required_providers {
    google = {
      version = "~> 4.0"
    }
  }
}

/**
 * Task 1: Add IAM Role Bindings (project_iam_bindings)
 * - source: "terraform-google-modules/iam/google//modules/projects_iam"
 * - version: "~> 7.4.0"
 * - projects: [var.project_id]
 * - mode: "additive"
 * - bindings:
 *   - Members: "serviceAccount:sa-cft-training@${var.project_id}.iam.gserviceaccount.com"
 *   - Role:
 *     - "roles/cloudfunctions.admin"
 *     - "roles/compute.admin"
 *     - "roles/compute.networkAdmin"
 *     - "roles/iam.serviceAccountAdmin"
 *     - "roles/serviceusage.serviceUsageAdmin"
 *     - "roles/storage.admin"
 *
 * Reference - https://github.com/terraform-google-modules/terraform-google-iam
 *
 */
# locals {
#   sa1=google_service_account.sa1.email
# }
module "project_iam_bindings" {
  source = "terraform-google-modules/iam/google//modules/projects_iam"
  projects = [var.project_id]
  mode = "additive"

  bindings = {
    "roles/browser" = [
       "user:liululu@google.com"
    ]
  }

  conditional_bindings = [
    {
      role = "roles/browser"
      title = "expires_after_2022_11_01"
      description = "Expiring at midnight of 2022-11-01"
      expression = "request.time < timestamp(\"2022-11-01T00:00:00Z\")"
      members = ["serviceAccount:sa-cft-training@first-proj-363422.iam.gserviceaccount.com"]
    }
  ]
}

