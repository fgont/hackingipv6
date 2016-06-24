#!/bin/bash


# Specify a drop policy (default deny)
ip6tables -P INPUT ACCEPT
ip6tables -P FORWARD DROP
ip6tables -P OUTPUT ACCEPT



# From/to traffic
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
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type redirect -j ACCEPT

# Allow incoming and outgoing ICMPv6 PTB
ip6tables -A INPUT -p icmpv6 --icmpv6-type packet-too-big -j ACCEPT
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type packet-too-big -j ACCEPT

# Allow outgoing ping
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type echo-request -j ACCEPT
ip6tables -A INPUT -p icmpv6 --icmpv6-type echo-request -i eth0 -j ACCEPT
ip6tables -A INPUT -p icmpv6 --icmpv6-type echo-reply -j ACCEPT

# Allow outgoing traceroute
ip6tables -A INPUT -p icmpv6 --icmpv6-type port-unreachable -j ACCEPT
ip6tables -A INPUT -p icmpv6 --icmpv6-type ttl-zero-during-transit -j ACCEPT


# Allow outgoing traceroute FROM LOCAL NETWORK
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type port-unreachable -o eth0 -j ACCEPT
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type ttl-zero-during-transit -o eth0 -j ACCEPT


# Block all other ICMPv6
ip6tables -A INPUT -p icmpv6 -j DROP
ip6tables -A OUTPUT -p icmpv6 -j DROP


# FORWARD traffic
ip6tables -A FORWARD -m ipv6header --header auth --soft -j DROP
ip6tables -A FORWARD -m ipv6header --header esp --soft -j DROP
ip6tables -A FORWARD -m ipv6header --header  dst --soft -j DROP
ip6tables -A FORWARD -m ipv6header --header  route --soft -j DROP
ip6tables -A FORWARD -m ipv6header --header  hop --soft -j DROP
ip6tables -A FORWARD -m ipv6header --header  frag --soft -j ACCEPT
ip6tables -A FORWARD -p tcp -j ACCEPT
ip6tables -A FORWARD -p udp -j ACCEPT

ip6tables -A FORWARD -p icmpv6 --icmpv6-type echo-request ! -i eth0 -j DROP
ip6tables -A FORWARD -p icmpv6 --icmpv6-type echo-reply -i eth0 -j DROP

ip6tables -A FORWARD -p icmpv6 --icmpv6-type ttl-zero-during-transit -i eth0 -j DROP
ip6tables -A FORWARD -p icmpv6 --icmpv6-type port-unreachable -i eth0 -j DROP
ip6tables -A FORWARD -p icmpv6 -j ACCEPT



