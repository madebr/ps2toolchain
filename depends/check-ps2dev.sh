#!/bin/bash
# check-pspdev.sh by Naomi Peori (naomi@peori.ca)

source ../ps2dev.sh || { echo "ERROR: Unable to process ps2dev.sh."; exit 1; }

## Check for the $PS2DEV directory.
mkdir -p $PS2DEV 1> /dev/null || { echo "ERROR: Create $PS2DEV before continuing."; exit 1; }

## Check for the $PS2SDK directory.
mkdir -p $PS2SDK 1> /dev/null || { echo "ERROR: Create $PS2SDK before continuing."; exit 1; }

## Check for $PS2DEV write permission.
touch $PS2DEV/test.tmp 1> /dev/null || { echo "ERROR: Grant write permissions for $PS2DEV before continuing."; exit 1; }

## Check for $PS2SDK write permission.
touch $PS2SDK/test.tmp 1> /dev/null || { echo "ERROR: Grant write permissions for $PS2SDK before continuing."; exit 1; }

## Check for $PS2DEV/bin in the path.
echo $PATH | grep $PS2DEV/bin 1> /dev/null || { echo "ERROR: Add $PS2DEV/bin to your path before continuing."; exit 1; }

## Check for $PS2DEV/ee/bin in the path.
echo $PATH | grep $PS2DEV/ee/bin 1> /dev/null || { echo "ERROR: Add $PS2DEV/ee/bin to your path before continuing."; exit 1; }

## Check for $PS2DEV/iop/bin in the path.
echo $PATH | grep $PS2DEV/iop/bin 1> /dev/null || { echo "ERROR: Add $PS2DEV/iop/bin to your path before continuing."; exit 1; }

## Check for $PS2DEV/dvp/bin in the path.
echo $PATH | grep $PS2DEV/dvp/bin 1> /dev/null || { echo "ERROR: Add $PS2DEV/dvp/bin to your path before continuing."; exit 1; }

## Check for $PS2SDK/bin in the path.
echo $PATH | grep $PS2SDK/bin 1> /dev/null || { echo "ERROR: Add $PS2SDK/bin to your path before continuing."; exit 1; }
