#!/bin/bash

# Delete the Ruleset
ip6tables -F

# Delete user-defined chains
ip6tables -X

# Define a policy
ip6tables -P INPUT ACCEPT
ip6tables -P FORWARD ACCEPT
ip6tables -P OUTPUT ACCEPT



