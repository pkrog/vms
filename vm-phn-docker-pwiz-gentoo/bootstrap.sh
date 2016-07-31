#!/bin/bash

sudo emerge --sync
sudo emerge app-emulation/docker
emerge -uDU --with-bdeps=y git
mkdir dev
cd dev
git clone --recursive https://github.com/phnmnl/docker-pwiz
