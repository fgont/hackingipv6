#!/bin/bash


# Specify a drop policy (default deny)
ip6tables -P INPUT ACCEPT
ip6tables -P FORWARD ACCEPT
ip6tables -P OUTPUT ACCEPT


# FORWARD traffic
ip6tables -A FORWARD -m ipv6header --header auth --soft -j DROP
ip6tables -A FORWARD -m ipv6header --header esp --soft -j DROP
ip6tables -A FORWARD -m ipv6header --header  dst --soft -j DROP
ip6tables -A FORWARD -m ipv6header --header  route --soft -j DROP
ip6tables -A FORWARD -m ipv6header --header  hop --soft -j DROP
ip6tables -A FORWARD -m ipv6header --header  frag --soft -j DROP


