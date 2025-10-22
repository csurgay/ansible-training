for i in {1..3}; do podman run --name host$i --hostname host$i -d --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 202$i:22 -p 808$i:80 --network ansible --mac-address 10:10:10:10:10:1$i docker.io/csurgay/managedhost; done

sleep 3

for i in {1..3}; do podman inspect host$i | grep -E "IPAddress|MacAddress"; done

