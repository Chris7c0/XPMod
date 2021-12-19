#!/bin/bash

# compile xpmod
./spcomp xpmod.sp -v:0

# Copy the new smx file into the test server
cp ./xpmod.smx /home/steam/l4d2testing/left4dead2/addons/sourcemod/plugins/

# Print the timestamp of the build completion
timestamp=$(date +%Y-%m-%d\ %H:%M:%S)
echo "                                     " $timestamp