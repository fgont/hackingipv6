#!/bin/bash


# Specify a drop policy (default allow)
ip6tables -P INPUT ACCEPT
ip6tables -P FORWARD DROP
ip6tables -P OUTPUT ACCEPT


# NEIGHBOR DISCOVERY MESSAGES
# ===========================
# Allow NS/NA messages both incoming and outgoing
ip6tables -A INPUT -p icmpv6 --icmpv6-type neighbor-solicitation -j ACCEPT
ip6tables -A INPUT -p icmpv6 --icmpv6-type neighbor-advertisement -j ACCEPT
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type neighbor-solicitation -j ACCEPT
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type neighbor-advertisement -j ACCEPT

# Allow SLAAC messages
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type router-solicitation -j ACCEPT
ip6tables -A INPUT -p icmpv6 --icmpv6-type router-advertisement -j ACCEPT
ip6tables -A INPUT -p icmpv6 --icmpv6-type redirect -j ACCEPT


# Allow ICMPv6 PTB
ip6tables -A INPUT -p icmpv6 --icmpv6-type packet-too-big -j ACCEPT


# Allow outgoing ping
ip6tables -A OUTPUT -p icmpv6 --icmpv6-type echo-request -j ACCEPT
ip6tables -A INPUT -p icmpv6 --icmpv6-type echo-reply -j ACCEPT


# Allow outgoing traceroute
ip6tables -A INPUT -p icmpv6 --icmpv6-type port-unreachable -j ACCEPT
ip6tables -A INPUT -p icmpv6 --icmpv6-type ttl-zero-during-transit    -j ACCEPT




# Block the rest
ip6tables -A INPUT -p icmpv6 -j DROP
ip6tables -A OUTPUT -p icmpv6 -j DROP



