docker build -t suse/mongodb:latest -t suse/mongodb:0.53 --force-rm .


docker run -ti --cap-add SYS_ADMIN -e "container=docker" --tmpfs /run --tmpfs /run/lock --tmpfs /tmp -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v data:/var/lib/mongodb:rw --rm --name mongo suse/mongodb
