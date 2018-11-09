data "terraform_remote_state" "research_subnet" {
  backend = "atlas"

  config {
    name = "${var.org}/${var.research_workspace}"
  }
}

