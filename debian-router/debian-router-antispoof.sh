#!/bin/bash

# Specify a drop policy (default drop)
ip6tables -P INPUT ACCEPT
ip6tables -P FORWARD ACCEPT
ip6tables -P OUTPUT ACCEPT


# Antispoof
ip6tables -A FORWARD -s fe80::/10 -j DROP
ip6tables -A FORWARD -i enp0s3 ! -s fc00:1::/64 -j DROP
ip6tables -A FORWARD -i enp0s8 ! -s fc00:2::/64 -j DROP

#Your local prefix (e.g., fc00:1::/32)
#Loopback address (::1/128)
#Multicast addresses (ff00::/8)
#Unspecified address (::/128)
#Link-local addresses (fe80::/10)
#Unique-Local Addresses (fc00::/7)
#GUAs NOT yet delegated by IANA (! 2000::/3)


ip6tables -A FORWARD  -s ::/128 -j DROP
ip6tables -A FORWARD  -s ff00::/8 -j DROP
#ip6tables -A FORWARD -i eth2 -s ::/128 -j DROP
ip6tables -A FORWARD -i enp0s9 ! -s 2000::/3 -j DROP

ip6tables -A FORWARD -i enp0s9  -s fc00:1::/64 -j DROP
ip6tables -A FORWARD -i enp0s9  -s fc00:2::/64 -j DROP

