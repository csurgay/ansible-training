podman run --name ansible --hostname ansible -d --network ansible docker.io/csurgay/rootless_controlnode
for i in {1..3}; do podman run --name host$i --privileged --hostname host$i -d -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 292$i:22 -p 898$i:80 --network ansible --mac-address 10:10:10:10:10:1$i docker.io/csurgay/rootless_managedhost; done

