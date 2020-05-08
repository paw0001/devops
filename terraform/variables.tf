variable project {
  description = "Project ID"
}

variable region {
  description = "Region"

  # Значение по умолчанию   
  default = "europe-west1"
}

variable disk_image {
  description = "Disk image"  
}

variable count_app {
	default = 1
}	
