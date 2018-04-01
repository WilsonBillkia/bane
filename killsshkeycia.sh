#!/bin/sh
#command to remove keys from .ssh/known_hosts during testing
ssh-keygen -f "~/.ssh/known_hosts" -R 192.168.33.16
