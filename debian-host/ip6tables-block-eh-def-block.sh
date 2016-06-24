#!/bin/bash

# Specify a drop policy (default drop)
ip6tables -P INPUT DROP
ip6tables -P FORWARD DROP
ip6tables -P OUTPUT DROP


# Antispoof
ip6tables -A FORWARD -s fe80::/10 -j DROP
ip6tables -A FORWARD -i eth0 ! -s fc00:1::/64 -j DROP
ip6tables -A FORWARD -i eth1 ! -s fc00:2::/64 -j DROP

# vboxnet is The Internet
#Your local prefix (e.g., fc00:1::/32)
#Loopback address (::1/128)
#Multicast addresses (ff00::/8)
#Unspecified address (::/128)
#Link-local addresses (fe80::/10)
#Unique-Local Addresses (fc00::/7)
#GUAs NOT yet delegated by IANA (! 2000::/3)

ip6tables -A FORWARD -i eth2 -s fc00:1::/64 -j DROP
ip6tables -A FORWARD -i eth2 -s fc00:2::/64 -j DROP
ip6tables -A FORWARD -i eth2 -s ::/128 -j DROP
ip6tables -A FORWARD -i eth2 -s ff00::/8 -j DROP
ip6tables -A FORWARD -i eth2 -s ::/128 -j DROP
ip6tables -A FORWARD -i eth2 ! -s 2000::/3 -j DROP





# Drop packets with IPv6 Extension Headers
ip6tables -A INPUT -m ipv6header --header  hop --soft  -j DROP
ip6tables -A OUTPUT -m ipv6header --header  hop --soft -j DROP
ip6tables -A FORWARD -m ipv6header --header  hop --soft  -j DROP


ip6tables -A INPUT -m ipv6header --header  dst --soft  -j DROP
ip6tables -A OUTPUT -m ipv6header --header  dst --soft  -j DROP
ip6tables -A FORWARD -m ipv6header --header  dst --soft  -j DROP

ip6tables -A INPUT -m ipv6header --header  route --soft -j DROP
ip6tables -A OUTPUT -m ipv6header --header route --soft -j DROP
ip6tables -A FORWARD -m ipv6header --header route --soft -j DROP


# Drop packets with IPv6 Extension Headers
ip6tables -A INPUT -m ipv6header --header frag --soft  -j DROP
ip6tables -A OUTPUT -m ipv6header --header frag --soft -j DROP
ip6tables -A FORWARD -m ipv6header --header frag --soft -j DROP


ip6tables -A INPUT -m ipv6header --header auth --soft -j DROP
ip6tables -A OUTPUT -m ipv6header --header  auth --soft -j DROP
ip6tables -A FORWARD -m ipv6header --header auth --soft -j DROP

ip6tables -A INPUT -m ipv6header --header esp --soft -j DROP
ip6tables -A OUTPUT -m ipv6header --header esp --soft -j DROP
ip6tables -A FORWARD -m ipv6header --header esp --soft -j DROP





# NEIGHBOR DISCOVERY MESSAGES
# ===========================
# Allow NS/NA messages both incoming and outgoing
ip6tables -A INPUT -p icmpv6 --icmpv6-type neighbor-solicitation -j ACCEPT
ip6tables -A INPUT -p icmpv6 --icmpv6-type neighbor-advertisement -j ACCEPT
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type neighbor-solicitation -j ACCEPT
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type neighbor-advertisement -j ACCEPT

# Allow SLAAC messages
ip6tables -A INPUT -p icmpv6 --icmpv6-type router-solicitation -j ACCEPT
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type router-advertisement -j ACCEPT

# Allow ICMPv6 Echo

ip6tables -A INPUT -p icmpv6 --icmpv6-type echo-request -j ACCEPT
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type echo-reply -j ACCEPT
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type echo-request -j ACCEPT
ip6tables -A INPUT -p icmpv6 --icmpv6-type echo-reply -j ACCEPT
ip6tables -A FORWARD -p icmpv6 --icmpv6-type echo-request -j ACCEPT
ip6tables -A FORWARD -p icmpv6 --icmpv6-type echo-reply -j ACCEPT


# Statefuly allow ICMPv6 Echo
#ip6tables -A INPUT -p icmpv6 --icmpv6-type echo-request -j ACCEPT
#ip6tables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
#ip6tables -A OUTPUT -p icmpv6 --icmpv6-type echo-request -j ACCEPT
#ip6tables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
#ip6tables -A FORWARD -p icmpv6 --icmpv6-type echo-request -j ACCEPT
#ip6tables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT



# ttl-zero-during-transit
# Allow traceroute frm vboxnet 0, but not from anywhere else
ip6tables -A INPUT -p icmpv6 --icmpv6-type ttl-zero-during-transit -j ACCEPT
ip6tables -A FORWARD -o eth0 -p icmpv6 --icmpv6-type ttl-zero-during-transit -j ACCEPT
ip6tables -A OUTPUT -o eth0 -p icmpv6 --icmpv6-type ttl-zero-during-transit -j ACCEPT


# ttl-zero-during-transit
# Allow traceroute everywhere
#ip6tables -A OUTPUT -p icmpv6 --icmpv6-type ttl-zero-during-transit -j ACCEPT
#ip6tables -A INPUT -p icmpv6 --icmpv6-type ttl-zero-during-transit -j ACCEPT
#ip6tables -A FORWARD -p icmpv6 --icmpv6-type ttl-zero-during-transit -j ACCEPT






# port unreach
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type port-unreachable -j ACCEPT
ip6tables -A INPUT -p icmpv6 --icmpv6-type port-unreachable -j ACCEPT
ip6tables -A FORWARD -p icmpv6 --icmpv6-type port-unreachable -j ACCEPT



# port unreach
ip6tables -A OUTPUT -p udp -j ACCEPT
#ip6tables -A INPUT -p udp -j ACCEPT
ip6tables -A FORWARD -p udp -j ACCEPT




# Allow SSH
ip6tables -A INPUT -p tcp --source-port 22 -j ACCEPT
ip6tables -A INPUT -p tcp --destination-port 22 -j ACCEPT
ip6tables -A OUTPUT -p tcp --source-port 22 -j ACCEPT
ip6tables -A OUTPUT -p tcp --destination-port 22 -j ACCEPT
ip6tables -A FORWARD -p tcp --destination-port 22 -j ACCEPT
ip6tables -A FORWARD -p tcp --source-port 22 -j ACCEPT


# Allow prot 80 (for testing)
ip6tables -A FORWARD -p tcp --destination-port 80 -j ACCEPT

