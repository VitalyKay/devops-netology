resource "yandex_vpc_network" "default" {
}

resource "yandex_vpc_subnet" "default" {
  name           = terraform.workspace == "prod" ? "subnet-prod" : "subnet-stage"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.default.id}"
  v4_cidr_blocks = terraform.workspace == "prod" ? ["192.168.101.0/24"] : ["192.168.102.0/24"]
}

#resource "yandex_compute_instance" "node" {
#  name                      = terraform.workspace == "prod" ? "node${count.index}-prod" : "node${count.index}-stage"
#  zone                      = "ru-central1-a"
#  hostname                  = terraform.workspace == "prod" ? "node${count.index}-prod.netology.yc" : "node${count.index}-stage.netology.yc"
#  allow_stopping_for_update = true
#  count = terraform.workspace == "prod" ? 2 : 1
#
#  resources {
#    cores  = terraform.workspace == "prod" ? 4 : 2
#    memory = terraform.workspace == "prod" ? 4 : 2
#  }
#
#  boot_disk {
#    initialize_params {
#      image_id    = "fd8hqa9gq1d59afqonsf"
#      type        = "network-nvme"
#      size        = "10"
#    }
#  }
#
#  network_interface {
#    subnet_id  = "${yandex_vpc_subnet.default.id}"
#    nat        = true
#  }
#
#  metadata = {
#    ssh-keys = "centos:${file("~/.ssh/id_ed25519.pub")}"
#  }
#}

resource "yandex_compute_instance" "node-foreach" {
  for_each = toset(terraform.workspace == "prod" ? ["node01","node02"] : ["node01"])
#  name                      = "${each.value}-${terraform.workspace == "prod" ? "prod" : "stage"}"
  zone                      = "ru-central1-a"
#  hostname                  = "${each.value}-${terraform.workspace == "prod" ? "prod" : "-stage"}.netology.yc"
  allow_stopping_for_update = true

  lifecycle {
    create_before_destroy = true
  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id    = "fd8hqa9gq1d59afqonsf"
      type        = "network-nvme"
      size        = "10"
    }
  }

  network_interface {
    subnet_id  = "${yandex_vpc_subnet.default.id}"
    nat        = true
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_ed25519.pub")}"
  }
}