#!/bin/bash
cd pangolin 
conda env create -f environment.yml
#conda activate pangolin 
yes | pip install .
rm -rf /root/.cache/pip
pangolin --version &> /pangolin-version.txt
