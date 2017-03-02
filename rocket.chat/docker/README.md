sudo docker build -t suse/rocket.chat:latest -t suse/rocket.chat:0.53 --force-rm .
sudo docker run -ti --cap-add SYS_ADMIN -e container=docker --tmpfs /run --tmpfs /tmp -v /sys/fs/cgroup:/sys/fs/cgroup:ro --rm --name rocket.chat suse/rocket.chat
