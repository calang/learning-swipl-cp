#!/usr/bin/env bash

# Run from the top level directory:
# $ this_file


# exit on any command failure
# or usage of undefined variable 
# or failure of any command within a pipaline
set -euo pipefail

# ensure this runs under root/sudo
#if [ "$EUID" -ne 0 ]
#	then echo "Please run as root"
#	exit 1
#fi

#set -x

swipl -s 'src/init' -g 'show_timetables,halt' 'src/timetable.pl'

