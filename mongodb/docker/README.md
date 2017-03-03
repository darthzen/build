docker build -t suse/mongodb:latest -t suse/mongodb:0.53 --force-rm .


docker run -d -v data:/var/lib/mongodb:rw --name mongo  suse/mongodb
