locals {
  project = "myapp"
  env     = terraform.workspace
  name    = "${local.project}-${local.env}"
}
