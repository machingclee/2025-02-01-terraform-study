terraform {
  cloud {

    organization = "james_limited"

    workspaces {
      name = "james-dev"
    }
  }
}
