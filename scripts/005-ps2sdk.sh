#!/bin/bash
# ps2sdk.sh by Naomi Peori (naomi@peori.ca)
# changed to use Git by Mathias Lafeldt <misfire@debugon.org>

# Source the PS2DEV environment
source ../ps2dev.sh || { exit 1; }

# make sure ps2sdk's makefile does not use it
unset PS2SDKSRC

## Download the source code.
if test ! -d "ps2sdk/.git"; then
	git clone https://github.com/ps2dev/ps2sdk && cd ps2sdk || exit 1
else
	cd ps2sdk || exit 1

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

## Determine the maximum number of processes that Make can work with.
## MinGW's Make doesn't work properly with multi-core processors.
OSVER=$(uname)
if [ ${OSVER:0:10} == MINGW32_NT ]; then
	PROC_NR=2
elif [ ${OSVER:0:6} == Darwin ]; then
	PROC_NR=$(sysctl -n hw.ncpu)
else
	PROC_NR=$(nproc)
fi

## Store the current branch
SDKBRANCH=`git branch -l | grep \* | cut -d ' ' -f2-`

## Stash the locally changed files.
git stash save 'toolchain.sh' || exit 1

## Checkout the latest origin/master source in detached HEAD mode to avoid
## rebasing if origin was force pushed.
## While in this mode, no branches will be affected or commits saved unless
## git checkout -b <branch> is used to create a branch.
git checkout FETCH_HEAD || exit 1

## Build and install
make clean && make -j $PROC_NR && make install && make clean

## Checkout the saved branch to exit detached HEAD mode
git checkout $SDKBRANCH || exit 1

## Restore the locally changed files.
git stash pop || exit 1

