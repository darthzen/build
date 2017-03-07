docker build -t suse/apache2:latest -t suse/apache2:2.4.23 --force-rm .


docker run -d --name apache --link=rocket.chat:rocketchat --tmpfs /tmp --tmpfs /run -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v vhosts:/etc/apache2/vhosts.d -v /etc/ssl:/etc/ssl suse/apache2
