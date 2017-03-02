docker build -t suse/mongodb:latest -t suse/mongodb:0.53 --force-rm .
docker run -ti --cap-add SYS_ADMIN -e container=docker --tmpfs /run --tmpfs /tmp -v /sys/fs/cgroup:/sys/fs/cgroup:ro --rm --name mongo suse/mongodb
