log() {
	printf "\n##########################################\n"
	printf "$1"
	printf "\n##########################################\n"
	printf "\n"
}

log "Rebuild sctipt starting"

podman rmi -fa

log "All root images and containers removed"

podman network create ansible

log "Podman network created"

cd ../controlnode
./build.sh

log "Controlnode image is built"

podman tag controlnode docker.io/csurgay/controlnode:latest
podman push docker.io/csurgay/controlnode:latest

log "Controlnode image is pushed to public registry"

cd ../managedhost
./build.sh

log "Managedhost image is built"

podman tag managedhost docker.io/csurgay/managedhost:latest
podman push docker.io/csurgay/managedhost:latest

log "Managedhost image pushed to public registry"

