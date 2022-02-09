#!/bin/bash

# public network
sudo ip l set ens19 up
#mudei public de .64 para .0 (mais facil)
sudo docker network create public_net1 -d macvlan -o parent=ens19 --subnet=172.31.255.0/24 --gateway=172.31.255.254
sudo docker network create public_net2 --subnet=172.32.255.0/24 --gateway=172.32.255.254
sudo docker network create public_net3 --subnet=172.33.255.0/24 --gateway=172.33.255.254
sudo docker network create public_net4 --subnet=172.34.255.0/24 --gateway=172.34.255.254
sudo docker network create public_net5 --subnet=172.35.255.0/24 --gateway=172.35.255.254
sudo docker network create public_net6 --subnet=172.36.255.0/24 --gateway=172.36.255.254

# AS200 nets
sudo docker network create as200_net --subnet=10.0.2.0/29 --gateway=10.0.2.6
sudo docker network create as200_pub1_net --subnet=172.16.123.144/28 --gateway=172.16.123.145

# AS300 nets
sudo docker network create as300_pub1_net --subnet=172.16.123.80/28 --gateway=172.16.123.81

# AS400 nets
sudo docker network create as400_net --subnet=10.0.4.0/29 --gateway=10.0.4.6
sudo docker network create as400_pub1_net --subnet=172.16.123.16/28 --gateway=172.16.123.17

# AS500 nets
sudo docker network create as500_net1 --subnet=10.0.5.0/29 --gateway=10.0.5.6
sudo docker network create as500_net2 --subnet=10.0.5.8/29 --gateway=10.0.5.14
sudo docker network create as500_net3 --subnet=10.0.5.16/29 --gateway=10.0.5.22
sudo docker network create as500_net4 --subnet=10.0.5.24/29 --gateway=10.0.5.30
sudo docker network create as500_net5 --subnet=10.0.5.32/29 --gateway=10.0.5.38
sudo docker network create as500_net6 --subnet=10.0.5.40/29 --gateway=10.0.5.45
sudo docker network create as500_pub1_net --subnet=172.16.123.32/28 --gateway=172.16.123.33

# AS600 nets
sudo docker network create as600_net --subnet=10.0.6.0/29 --gateway=10.0.6.6
sudo docker network create as600_pub1_net --subnet=172.16.123.48/28 --gateway=172.16.123.49


# AS200 routers
echo ">>>>R1.AS200"
sudo docker run -d --net as200_net --ip 10.0.2.1 \
    -v /home/gors/quagga/zebra.conf:/etc/quagga/zebra.conf \
    -v /home/gors/quagga/ospfd.conf:/etc/quagga/ospfd.conf \
    -v /home/gors/quagga/bgpd-as200-router1.conf:/etc/quagga/bgpd.conf \
    -v /home/gors/quagga/start-ospf-bgp.sh:/root/start.sh \
    --cap-add=NET_ADMIN  --privileged --name as200_router1 netubuntu 
sudo docker network connect public_net1 as200_router1 --ip 172.31.255.125
sudo docker exec as200_router1 /bin/bash -c 'ip r del default via 10.0.2.6'

echo ">>>>R2.AS200"
sudo docker run -d --net as200_net --ip 10.0.2.2 \
    -v /home/gors/quagga/zebra.conf:/etc/quagga/zebra.conf \
    -v /home/gors/quagga/ospfd.conf:/etc/quagga/ospfd.conf \
    -v /home/gors/quagga/bgpd-as200-router2.conf:/etc/quagga/bgpd.conf \
    -v /home/gors/quagga/start-ospf-bgp.sh:/root/start.sh \
    --cap-add=NET_ADMIN  --privileged --name as200_router2 netubuntu 
sudo docker network connect as200_pub1_net as200_router2 --ip 172.16.123.158
sudo docker network connect public_net3 as200_router2 --ip 172.33.255.253
sudo docker exec as200_router2 /bin/bash -c 'ip r del default via 10.0.2.6'

echo ">>>>R3.AS200"
sudo docker run -d --net as200_net --ip 10.0.2.3 \
    -v /home/gors/quagga/zebra.conf:/etc/quagga/zebra.conf \
    -v /home/gors/quagga/ospfd.conf:/etc/quagga/ospfd.conf \
    -v /home/gors/quagga/bgpd-as200-router3.conf:/etc/quagga/bgpd.conf \
    -v /home/gors/quagga/start-ospf-bgp.sh:/root/start.sh \
    --cap-add=NET_ADMIN  --privileged --name as200_router3 netubuntu 
sudo docker network connect public_net5 as200_router3 --ip 172.35.255.252
sudo docker exec as200_router3 /bin/bash -c 'ip r del default via 10.0.2.6'


# AS300 routers
echo ">>>>R1.AS300"
sudo docker run -d --net as300_pub1_net --ip 172.16.123.94 \
    -v /home/gors/quagga/zebra.conf:/etc/quagga/zebra.conf \
    -v /home/gors/quagga/ospfd.conf:/etc/quagga/ospfd.conf \
    -v /home/gors/quagga/bgp-as300.conf:/etc/quagga/bgpd.conf \
    -v /home/gors/quagga/start-ospf-bgp.sh:/root/start.sh \
    --cap-add=NET_ADMIN  --privileged --name as300_router1 netubuntu 
sudo docker network connect public_net5 as300_router1 --ip 172.35.255.253
sudo docker network connect public_net6 as300_router1 --ip 172.36.255.252

# AS400 routers
echo ">>>>R1.AS400"
sudo docker run -d --net as400_net --ip 10.0.4.1 \
    -v /home/gors/quagga/zebra.conf:/etc/quagga/zebra.conf \
    -v /home/gors/quagga/ospfd.conf:/etc/quagga/ospfd.conf \
    -v /home/gors/quagga/bgpd-as400-router1.conf:/etc/quagga/bgpd.conf \
    -v /home/gors/quagga/start-ospf-bgp.sh:/root/start.sh \
    --cap-add=NET_ADMIN  --privileged --name as400_router1 netubuntu 
sudo docker network connect public_net1 as400_router1 --ip 172.31.255.124
sudo docker exec as400_router1 /bin/bash -c 'ip r del default via 10.0.4.6'


echo ">>>>R2.AS400"
sudo docker run -d --net as400_net --ip 10.0.4.2 \
    -v /home/gors/quagga/zebra.conf:/etc/quagga/zebra.conf \
    -v /home/gors/quagga/ospfd.conf:/etc/quagga/ospfd.conf \
    -v /home/gors/quagga/bgpd-as400-router2.conf:/etc/quagga/bgpd.conf \
    -v /home/gors/quagga/start-ospf-bgp.sh:/root/start.sh \
    --cap-add=NET_ADMIN  --privileged --name as400_router2 netubuntu 
sudo docker network connect as400_pub1_net as400_router2 --ip 172.16.123.30
sudo docker network connect public_net2 as400_router2 --ip 172.32.255.253
sudo docker exec as400_router2 /bin/bash -c 'ip r del default via 10.0.4.6'


# AS500 routers
echo ">>>>R1.AS500"
sudo docker run -d --net as500_net1 --ip 10.0.5.2 \
    -v /home/gors/quagga/zebra.conf:/etc/quagga/zebra.conf \
    -v /home/gors/quagga/ospfd.conf:/etc/quagga/ospfd.conf \
    -v /home/gors/quagga/bgp-as500-router1.conf:/etc/quagga/bgpd.conf \
    -v /home/gors/quagga/start-ospf-bgp.sh:/root/start.sh \
    --cap-add=NET_ADMIN  --privileged --name as500_router1 netubuntu 
sudo docker network connect as500_net2 as500_router1 --ip 10.0.5.10
sudo docker network connect public_net3 as500_router1 --ip 172.33.255.252
sudo docker exec as500_router1 /bin/bash -c 'ip r del default via 10.0.5.6'

echo ">>>>R2.AS500"
sudo docker run -d --net as500_net1 --ip 10.0.5.3 \
    -v /home/gors/quagga/zebra.conf:/etc/quagga/zebra.conf \
    -v /home/gors/quagga/ospfd.conf:/etc/quagga/ospfd.conf \
    -v /home/gors/quagga/bgp-as500-router2.conf:/etc/quagga/bgpd.conf \
    -v /home/gors/quagga/start-ospf-bgp.sh:/root/start.sh \
    --cap-add=NET_ADMIN  --privileged --name as500_router2 netubuntu 
sudo docker network connect as500_net4 as500_router2 --ip 10.0.5.26
sudo docker network connect public_net2 as500_router2 --ip 172.32.255.252
sudo docker exec as500_router2 /bin/bash -c 'ip r del default via 10.0.5.6'

echo ">>>>R3.AS500"
sudo docker run -d --net as500_net2 --ip 10.0.5.11 \
    -v /home/gors/quagga/zebra.conf:/etc/quagga/zebra.conf \
    -v /home/gors/quagga/ospfd.conf:/etc/quagga/ospfd.conf \
    -v /home/gors/quagga/start-ospf-bgp.sh:/root/start.sh \
    --cap-add=NET_ADMIN  --privileged --name as500_router3 netubuntu 
sudo docker network connect as500_net5 as500_router3 --ip 10.0.5.35
sudo docker network connect as500_net3 as500_router3 --ip 10.0.5.18
sudo docker exec as500_router3 /bin/bash -c 'ip r del default via 10.0.5.14'

echo ">>>>R4.AS500"
sudo docker run -d --net as500_net4 --ip 10.0.5.27 \
    -v /home/gors/quagga/zebra.conf:/etc/quagga/zebra.conf \
    -v /home/gors/quagga/ospfd.conf:/etc/quagga/ospfd.conf \
    -v /home/gors/quagga/start-ospf-bgp.sh:/root/start.sh \
    --cap-add=NET_ADMIN  --privileged --name as500_router4 netubuntu 
sudo docker network connect as500_net5 as500_router4 --ip 10.0.5.34
sudo docker network connect as500_net6 as500_router4 --ip 10.0.5.42
sudo docker network connect as500_pub1_net as500_router4 --ip 172.16.123.46
sudo docker exec as500_router4 /bin/bash -c 'ip r del default via 10.0.5.30'

echo ">>>>R5.AS500"
sudo docker run -d --net as500_net3 --ip 10.0.5.19 \
    -v /home/gors/quagga/zebra.conf:/etc/quagga/zebra.conf \
    -v /home/gors/quagga/ospfd.conf:/etc/quagga/ospfd.conf \
    -v /home/gors/quagga/bgp-as500-router5.conf:/etc/quagga/bgpd.conf \
    -v /home/gors/quagga/start-ospf-bgp.sh:/root/start.sh \
    --cap-add=NET_ADMIN  --privileged --name as500_router5 netubuntu 
sudo docker network connect public_net4 as500_router5 --ip 172.34.255.253
sudo docker network connect as500_net6 as500_router5 --ip 10.0.5.43
sudo docker exec as500_router5 /bin/bash -c 'ip r del default via 10.0.5.22'


# AS600 routers
echo ">>>>R1.AS600"
sudo docker run -d --net as600_net --ip 10.0.6.2 \
    -v /home/gors/quagga/zebra.conf:/etc/quagga/zebra.conf \
    -v /home/gors/quagga/ospfd.conf:/etc/quagga/ospfd.conf \
    -v /home/gors/quagga/bgp-as600-router1.conf:/etc/quagga/bgpd.conf \
    -v /home/gors/quagga/start-ospf-bgp.sh:/root/start.sh \
    --cap-add=NET_ADMIN  --privileged --name as600_router1 netubuntu 
sudo docker network connect public_net4 as600_router1 --ip 172.34.255.252
sudo docker network connect as600_pub1_net as600_router1 --ip 172.16.123.62
sudo docker exec as600_router1 /bin/bash -c 'ip r del default via 10.0.6.6'

echo ">>>>R2.AS600"
sudo docker run -d --net as600_net --ip 10.0.6.3 \
    -v /home/gors/quagga/zebra.conf:/etc/quagga/zebra.conf \
    -v /home/gors/quagga/ospfd.conf:/etc/quagga/ospfd.conf \
    -v /home/gors/quagga/bgp-as600-router2.conf:/etc/quagga/bgpd.conf \
    -v /home/gors/quagga/start-ospf-bgp.sh:/root/start.sh \
    --cap-add=NET_ADMIN  --privileged --name as600_router2 netubuntu 
sudo docker network connect public_net6 as600_router2 --ip 172.36.255.253
sudo docker exec as600_router2 /bin/bash -c 'ip r del default via 10.0.6.6'


echo ">>>>S1.AS200"
sudo docker run -d --net as200_pub1_net --ip 172.16.123.146 --cap-add=NET_ADMIN --name as200_server1 netubuntu 
sudo docker exec as200_server1 /bin/bash -c 'ip r del default via 172.16.123.145'
sudo docker exec as200_server1 /bin/bash -c 'ip r add default via 172.16.123.158'

echo ">>>>S1.AS400"
sudo docker run -d --net as400_pub1_net --ip 172.16.123.18 --cap-add=NET_ADMIN --name as400_server1 netubuntu 
sudo docker exec as400_server1 /bin/bash -c 'ip r del default via 172.16.123.17'
sudo docker exec as400_server1 /bin/bash -c 'ip r add default via 172.16.123.30'

echo ">>>>S1.AS300"
sudo docker run -d --net as300_pub1_net --ip 172.16.123.82 --cap-add=NET_ADMIN --name as300_server1 netubuntu 
sudo docker exec as300_server1 /bin/bash -c 'ip r del default via 172.16.123.81'
sudo docker exec as300_server1 /bin/bash -c 'ip r add default via 172.16.123.94'

# echo ">>>>S1.AS500"
# sudo docker run -d --net as500_pub1_net --ip 172.16.123.34 --cap-add=NET_ADMIN --name as500_server1 netubuntu 
# sudo docker exec as500_server1 /bin/bash -c 'ip r del default via 172.16.123.33'
# sudo docker exec as500_server1 /bin/bash -c 'ip r add default via 172.16.123.46'

echo ">>>>S1.AS600"
sudo docker run -d --net as600_pub1_net --ip 172.16.123.50 --cap-add=NET_ADMIN --name as600_server1 netubuntu 
sudo docker exec as600_server1 /bin/bash -c 'ip r del default via 172.16.123.49'
sudo docker exec as600_server1 /bin/bash -c 'ip r add default via 172.16.123.62'
