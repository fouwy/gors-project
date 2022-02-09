#!/bin/bash
export GORS_HOME=`pwd`
$GORS_HOME/docker-prune.sh
scp -i /home/gors/g.rsa.txt -r $GORS_HOME/bgp-3peers-hw/quagga/ 192.168.109.151:~/.
$GORS_HOME/runremote.sh $GORS_HOME/bgp-3peers-hw/bgp-3peers-hw.sh   