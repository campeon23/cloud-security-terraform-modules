data "google_artifact_registry_repository" "existing_ecccloudlab_repo_ring" {
  repository_id = "ecccloudlab"
  location = "us-central1"
}

resource "google_artifact_registry_repository" "ecccloudlab_repo" {
  count = data.google_artifact_registry_repository.existing_ecccloudlab_repo_ring.id == null ? 1 : 0
  location      = "us-central1"
  repository_id = "ecccloudlab"
  format        = "DOCKER"

  description = "ECouncil Cloud Security Engineer Lab Repository."

  labels = {
    Name = "Ecccloudlab"
    Enviroment = "Development"
    Department = "Security"
  }

#   lifecycle {
#     prevent_destroy = true
#   }
}