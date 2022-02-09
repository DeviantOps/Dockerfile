#!/bin/bash
service ssh start
service mongodb start
service redis-server start
#
useradd -m -p yK9SGBCKF5AMI malcolm
usermod -aG sudo malcolm
# spawn a shell
/bin/bash
