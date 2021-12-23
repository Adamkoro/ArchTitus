#!/bin/bash

echo 'ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/scheduler}="none"' >> /etc/udev/rules.d/60-ssd-scheduler.rules
