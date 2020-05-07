provider "google" {   
    # Версия провайдера   
    version = "2.0.0"
   # ID проекта
   project = "numeric-button-274514"
   region = "europe-west-1" 
   }

 resource "google_compute_instance" "app" {   
   name         = "reddit-001"   
   machine_type = "g1-small"   
   zone         = "europe-west1-b"   
   # определение загрузочного диска   
   boot_disk {     
    initialize_params {       
     image = "reddit-base"     
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
   type = "ssh"
   user = "pawwwel"
   agent = false
   # путь до приватного ключа
   private_key = "${file("~/.ssh/id_rsa")}"
 }




   provisioner "file" 
   {   
    source = "files/puma.service"   
    destination = "/tmp/puma.service" 
   }

	provisioner "remote-exec" 
		{   
		script = "files/deploy.sh" 
		}

}
