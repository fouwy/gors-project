
/interface bridge add name=bgpprefixnet
/ip address add interface=bgpprefixnet address=172.16.123.130/28
/ip address add interface=ether6 address=172.31.255.126/24

/routing bgp instance set default as=100
/routing bgp peer add name=toas400 remote-address=172.31.255.124 remote-as=400
/routing bgp peer add name=toas200 remote-address=172.31.255.125 remote-as=200

#/routing bgp network add network=172.16.123.64/28 synchronize=no
/routing bgp instance set redistribute-static=yes numbers=default

/routing bgp peer set in-filter=as200-in out-filter=as200-out numbers=toas200
/routing bgp peer set in-filter=as400-in out-filter=as400-out numbers=toas400

/routing filter add chain=as200-out prefix=172.16.123.128/28 action=accept
/routing filter add chain=as400-out prefix=172.16.123.128/28 action=accept
