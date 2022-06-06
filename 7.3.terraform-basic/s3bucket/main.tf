
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = "ajev0i1e6sc0i9v1geho"
  description = "static access key for object storage"
}

resource "yandex_storage_bucket" "terraform_state" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "terraform-state-vitalykay"
}