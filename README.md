# ps2toolchain

This program will automatically build and install a compiler and other tools
used in the creation of homebrew software for the Sony PlayStation® 2 videogame
system.

## What these scripts do

These scripts download (with wget) and install:
 * [binutils 2.14](http://www.gnu.org/software/binutils/ "binutils") (ee/iop)
 * [gcc 3.2.3](https://gcc.gnu.org/ "gcc") (ee/iop)
 * [newlib 3.0.0](https://sourceware.org/newlib/ "newlib") (ee)
 * [ps2sdk](https://github.com/ps2dev/ps2sdk "ps2sdk")
 * [ps2client](https://github.com/ps2dev/ps2client "ps2client")

## Requirements

1. Install gcc/clang, make, patch, git, and wget if you don't have those.

2. Create the directory for the PS2DEV environment and make sure your user
   account has read/write permission for it.

3. Set the PS2DEV environment variable to that directory.
   ```sh
   export PS2DEV=/usr/local/ps2dev
   ./toolchain.sh
   ```

## ps2dev.sh

The toolchain.sh script creates a ps2dev.sh file that can be used to setup your
PS2DEV environment.

Copy it to your HOME directory and add this line to your .bashrc, or
.bash_profile, or .profile depending on the enviroment.  
`. ~/ps2dev.sh`

Or, you can source it manually if you don't wish to modify your global user
environment. Remember the environment is only set for that process and any
processes it creates.

## Steps

The toolchain.sh script uses numbered steps to build the PS2DEV environment.
The default is to build the full toolchain, ps2sdk, and ps2client.

To build and install a single step, provide a number signifying the step you
wish to execute. The steps are dependent upon the completion of the previous
steps. E.g. the second step won't build if the first step hasn't been built and
installed.

For example, to only build and install binutils:  
`./toolchain.sh 1`

The steps are:
1. binutils (for ee/iop/dvp)
2. gcc-stage1 (C for ee/iop)
3. newlib (for ee)
4. gcc-stage2 (C and C++ for ee)
5. ps2sdk
6. ps2client

