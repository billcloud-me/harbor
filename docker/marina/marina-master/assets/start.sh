#!/bin/sh
set -x
echo "hello"
/usr/bin/harbor-service-manage-auth
tail -f /dev/null

harbor-service-update kubernetes
harbor-service-update ipsilon
harbor-service-update memcached
harbor-service-update keystone
harbor-service-update messaging
harbor-service-update ovn
harbor-service-update neutron
harbor-service-update api
