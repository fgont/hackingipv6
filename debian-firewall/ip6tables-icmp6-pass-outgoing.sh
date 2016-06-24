#!/bin/bash


# Specify a drop policy (default deny)
ip6tables -P INPUT ACCEPT
ip6tables -P FORWARD ACCEPT
ip6tables -P OUTPUT ACCEPT


# Allow ICMPv6 Echo

ip6tables -A FORWARD -p icmpv6 --icmpv6-type echo-request -i eth0 -m state --state NEW -j ACCEPT
ip6tables -A FORWARD -p icmpv6 -m state --state ESTABLISHED -j ACCEPT
ip6tables -A FORWARD -p icmpv6 -j DROP













#ip6tables -A FORWARD -p icmpv6 --icmpv6-type echo-request -j DROP
#ip6tables -A FORWARD -p icmpv6 --icmpv6-type echo-reply -m limit --limit 1/minute --limit-burst 5 -j ACCEPT
#ip6tables -A FORWARD -p icmpv6 --icmpv6-type echo-reply   -j DROP


