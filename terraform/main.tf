provider "google" {
  # Версия провайдера   
  version = "2.0.0"

  # ID проекта
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_instance" "app" {
  name = "reddit-app-${count.index + 1}"
  count = "${var.count_app}"	
  machine_type = "g1-small"
  zone         = "europe-west1-b"
  tags = ["reddit-002"] 

  # определение загрузочного диска   
  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  # определение сетевого интерфейса   
  network_interface {
    # сеть, к которой присоединить данный интерфейс     
    network = "default"

    # использовать ephemeral IP для доступа из Интернет     
    access_config {}
  }

  connection {
    type  = "ssh"
    user  = "pawwwel"
    agent = false

    # путь до приватного ключа
    private_key = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

resource "google_compute_firewall" "firewall_puma" {   
	name = "allow-puma-default"   
	# Название сети, в которой действует правило   
	network = "default"   
	# Какой доступ разрешить   
	allow {
		 protocol = "tcp"
		 ports = ["9292"]   
	}   
	# Каким адресам разрешаем доступ   
	source_ranges = ["0.0.0.0/0"]   
	# Правило применимо для инстансов с перечисленными тэгами   
	target_tags = ["reddit-002"] 
}
