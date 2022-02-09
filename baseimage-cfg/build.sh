#!/bin/bash
export GORS_HOME=`pwd`
scp -i /home/gors/g.rsa.txt -r $GORS_HOME/baseimage-cfg/baseimage/ 192.168.109.151:~/.
ssh -i /home/gors/g.rsa.txt 192.168.109.151 'sudo docker build --tag netubuntu:latest ~/baseimage'