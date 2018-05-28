#!/bin/bash
# toolchain.sh by Naomi Peori (naomi@peori.ca)

## Enter the ps2toolchain directory.
cd "`dirname $0`" || { echo "ERROR: Could not enter the ps2toolchain directory."; exit 1; }

## Check if $PS2DEV is set.
if test ! $PS2DEV; then { echo 'ERROR: Set $PS2DEV before continuing.'; exit 1; } fi

## Create the PS2DEV environment script
echo 'Creating ps2dev.sh environment script'
echo '#!/bin/bash -u'                              >  ./ps2dev.sh
echo ""                                            >> ./ps2dev.sh
echo "export PS2DEV=\"$PS2DEV\""                   >> ./ps2dev.sh
echo 'export PS2SDK="$PS2DEV/ps2sdk"'              >> ./ps2dev.sh
echo ""                                            >> ./ps2dev.sh
echo 'export PATH="$PATH:$PS2DEV/ee/bin"'          >> ./ps2dev.sh
echo 'export PATH="$PATH:$PS2DEV/iop/bin"'         >> ./ps2dev.sh
echo 'export PATH="$PATH:$PS2DEV/dvp/bin"'         >> ./ps2dev.sh
echo 'export PATH="$PATH:$PS2SDK/bin:$PS2DEV/bin"' >> ./ps2dev.sh
chmod +x ./ps2dev.sh

## Create the build directory.
mkdir -p build || { echo "ERROR: Could not create the build directory."; exit 1; }

## Enter the build directory.
cd build || { echo "ERROR: Could not enter the build directory."; exit 1; }

## Fetch the depend scripts.
DEPEND_SCRIPTS=(`ls ../depends/*.sh | sort`)

## Run all the depend scripts.
for SCRIPT in ${DEPEND_SCRIPTS[@]}; do "$SCRIPT" || { echo "$SCRIPT: Failed."; exit 1; } done

## Fetch the build scripts.
BUILD_SCRIPTS=(`ls ../scripts/*.sh | sort`)

## If specific steps were requested...
if [ $1 ]; then

	## Run the requested build scripts.
	for STEP in $@; do "${BUILD_SCRIPTS[$STEP-1]}" || { echo "${BUILD_SCRIPTS[$STEP-1]}: Failed."; exit 1; } done

else

	## Run the all build scripts.
	for SCRIPT in ${BUILD_SCRIPTS[@]}; do "$SCRIPT" || { echo "$SCRIPT: Failed."; exit 1; } done

fi
