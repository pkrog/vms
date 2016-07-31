#!/bin/bash

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y python-pip
#pip install virtualenv
#virtualenv .venv; . .venv/bin/activate
pip install planemo
git clone --recursive https://github.com/workflow4metabolomics/lcmsmatching
