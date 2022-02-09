#!/bin/bash
service ssh start
service mongodb start
service redis-server start
#
useradd -m -p yK9SGBCKF5AMI malcolm
usermod -aG sudo malcolm
# start Jupyter
nohup jupyter notebook --notebook-dir=/opt/notebooks --ip='*' --port=8888 --no-browser --allow-root &
# spawn a shell
/bin/bash
