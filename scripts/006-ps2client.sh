#!/bin/bash
# ps2client.sh by Naomi Peori (naomi@peori.ca)
# changed to use Git by Mathias Lafeldt <misfire@debugon.org>

# Source the PS2DEV environment
source ../ps2dev.sh || { exit 1; }

## Download the source code.
if test ! -d "ps2client/.git"; then
	git clone https://github.com/boganon/ps2client && cd ps2client || exit 1
else
	cd ps2client || exit 1

	git branch -l | grep 'detached' &> /dev/null

	# The script may have been terminated or an error occurred while
	# building ps2sdk in detached HEAD mode. Just checkout master to exit
	# it. If a stash was saved then the user can decide to restore it
	# after ps2sdk is built. If a user modified files between then and
	# now in detached HEAD state, save those changes, too.
	if [ $? == 0 ]; then
		git stash save 'toolchain.sh' || exit 1
		git checkout master || exit 1
	fi
	# There may be conflicts if origin was force pushed so only fetch
	# the latest sources but don't try to merge them.
	git fetch origin || exit 1
fi

## Store the current branch
SDKBRANCH=`git branch -l | grep \* | cut -d ' ' -f2-`

## Stash the locally changed files.
git stash save 'toolchain.sh'

## Checkout the latest origin/master source in detached HEAD mode to avoid
## rebasing if origin was force pushed.
## While in this mode, no branches will be affected or commits saved unless
## git checkout -b <branch> is used to create a branch.
git checkout origin/master

## Build and install
echo 'Building ps2client'
make clean && make
BUILD_RET=$?

if [ $BUILD_RET == 0 ]; then
	echo 'Installing ps2client'
	make install && make clean
	INSTALL_RET=$?
fi

## Checkout the saved branch to exit detached HEAD mode
git checkout $SDKBRANCH

## Restore the locally changed files. (may exit 1 if no stash found)
git stash pop

## Check the return values
if [ $BUILD_RET != 0 ]; then
	echo "ERROR: Building ps2client failed."
	exit $BUILD_RET
else
	if [ $INSTALL_RET != 0 ]; then
		echo "ERROR: Installing ps2client failed."
		exit $INSTALL_RET
	fi
fi

exit 0
