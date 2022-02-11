#!/bin/bash

# This script will find the version number from a sourcemod plugin file (.sp) and increment it by 1
# It assumes this declaration format in the file:
# #define PLUGIN_VERSION "0.0.0.0000"

file_path="./xpmod.sp"

# Extract the version from the xpmod sp file
build_version_original=`cat $file_path | grep "define PLUGIN_VERSION" | cut -d'"' -f 2 | cut -d'.' -f 4`

# Increment build number by 1
build_version=`expr $build_version_original + 1`

# Handle a roll over from 9999 to 0000
# This probably shouldnt happen but whatever, it was easy to do
if [ $build_version -eq 10000 ]
then
    build_version=0
fi

# Recombine into a string with leading 0s
build_version_incremented=`printf "%04d\n" $build_version`

# Now replace in the actual file (matches pattern .0000")
sed -i -e "s/.$build_version_original\"/.$build_version_incremented\"/g" $file_path