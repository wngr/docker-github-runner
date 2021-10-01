#!/bin/bash
for i in `docker ps -q`; do docker container rm $i --force; done

for i in `seq 0 5`; do docker run -it -d --restart always --name runner-wngr-$i \
    -e RUNNER_NAME=runner-wngr-$i \
    -e RUNNER_TOKEN=$TOKEN \
    -e RUNNER_ORGANIZATION_URL=https://github.com/cloudpeers \
    tcardonne/github-runner; done


sudo iptables -I FORWARD -i docker0 -d 10.0.0.0/16 -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -I FORWARD -i docker0 -d 10.0.0.0/16 -j DROP
#dns
sudo iptables -I FORWARD -i docker0 -d 10.0.13.251/24 -j ACCEPT
