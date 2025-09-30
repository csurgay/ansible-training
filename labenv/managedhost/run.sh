for i in {1..3}; do podman run --name host$i --hostname host$i -d --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 292$i:22 -p 898$i:80 --network ansible --mac-address 10:10:10:10:10:1$i managedhost; done

sleep 3

for i in {1..3}; do podman inspect host$i | grep -E "IPAddress|MacAddress"; done

