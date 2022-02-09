#!/bin/bash
ssh -i /home/gors/g.rsa.txt 192.168.109.151 'sudo docker kill `sudo docker ps -aq`'
ssh -i /home/gors/g.rsa.txt 192.168.109.151 'sudo docker rm `sudo docker ps -aq`'
ssh -i /home/gors/g.rsa.txt 192.168.109.151 'sudo docker system prune -f'
ssh -i /home/gors/g.rsa.txt 192.168.109.151 'sudo rm -rf quagga'
