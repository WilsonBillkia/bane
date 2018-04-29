#!/bin/sh
#handy alias to remove keys from .ssh/known_hosts during testing on machines with ssh strict checking enabled  
ssh-keygen -f "/home/network/.ssh/known_hosts" -R 192.168.33.16
