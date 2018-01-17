data "terraform_remote_state" "vpc" {
  backend = "atlas"

  config {
    name = "${var.network-workspace}"
  }
}

provider "google" {
  region = "${data.terraform_remote_state.vpc.region}"
}

data "google_compute_image" "ubuntu" {
  family  = "ubuntu-1604-lts"
  project = "ubuntu-os-cloud"
}

resource "google_compute_instance" "web-server" {
  name         = "${data.terraform_remote_state.vpc.region}-web-server"
  machine_type = "${var.machine_type}"

  tags = ["web"]

  # all US regions have a 'c' zone
  zone = "${data.terraform_remote_state.vpc.region}-c"

  boot_disk {
    initialize_params {
      image = "${data.google_compute_image.ubuntu.self_link}"
    }
  }

  network_interface {
    subnetwork = "${data.terraform_remote_state.vpc.subnetwork_self_link}"

    access_config {
      // Ephemeral IP, allow outside connections
    }
  }
}
