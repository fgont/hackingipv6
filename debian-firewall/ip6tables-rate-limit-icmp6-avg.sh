#!/bin/bash


# Specify a drop policy (default deny)
ip6tables -P INPUT ACCEPT
ip6tables -P FORWARD ACCEPT
ip6tables -P OUTPUT ACCEPT


# Allow ICMPv6 Echo

ip6tables -A FORWARD -p icmpv6 --icmpv6-type echo-request  -m limit --limit 1/sec --limit-burst 1 -j ACCEPT
ip6tables -A FORWARD -p icmpv6 --icmpv6-type echo-request -j DROP


ip6tables -A FORWARD -p icmpv6 --icmpv6-type echo-reply -m limit --limit 1/sec --limit-burst 1 -j ACCEPT
ip6tables -A FORWARD -p icmpv6 --icmpv6-type echo-reply   -j DROP


