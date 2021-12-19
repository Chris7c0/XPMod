#!/bin/bash

# compile xpmod
./spcomp xpmod.sp -v:0

# Print the timestamp of the build completion
timestamp=$(date +%Y-%m-%d\ %H:%M:%S)
echo "                                     " $timestamp