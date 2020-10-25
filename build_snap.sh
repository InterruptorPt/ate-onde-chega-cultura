#!/bin/sh

# This script will just issue the necessary commands for you to build the snap.
#
# Why is this script needed:
# 1. The Flutter app code is not on the root directory of the repository
# 2. It assists all users to generate a snap packge for the flutter app, even if
# they don't know how to generate a snap package.
#
# What should users expect of it:
# 1. It will only work on a system that is already snap enabled, it will fail
# otherwise. And the user is expected to enable snap packages support by
# him/herself. Details on how to do it can be found at: https://snapcraft.io/docs/installing-snapd
# 2. If snapcraft is not installed it will be installed.


# TODO:
# 1. Output errros and warnings correctly to STDERR
# 2. Refactor to use functions
# X-1. Test!!!
# X. Get more items for the TODO list and improve it

# Possible exit status for the script:
# 0 - Succeed generating packge
# 1 - OS is currenlty not snap enabled
# 2 - Snapcraft is not installed and failed to install
# 3 - Failed changing into the directory that is the Flutter app base path
# 4 - Snapcraft exited with a non 0 exit status

echo "INFO: Checking if the Operating System is snap package enabled"
which snap
IS_SNAP_ENABLED=$? # if 0 yes 1 is no

if [[ ${IS_SNAP_ENABLED} -eq 1 ]]
then
  echo "ERROR: Your Operating System is not snap enabled."
  printf "WARN: To be able to generate a snap you need to have snap support and snapcraft installed.\nYou can learn how to enable snap packages support on your\nOperating System at: https://snapcraft.io/docs/installing-snapd\n\n"
  exit 1;
fi


which snapcraft
IS_SNAPCRAFT_INSTALLED=$?

if [[ ${IS_SNAPCRAFT_INSTALLED} -eq 1 ]]
then
  echo "WARN: Snapcraft is not installed, will install now"
  sudo snap install snapcraft --classic
  INSTALATION_SUCCEED=$?
  if [[ ${INSTALATION_SUCCEED} -ne 0 ]]
  then
    echo "ERROR: Snapcraft installation failed!"
    echo "WARN: Stopping snap package generation procedure"
    exit 2
  fi
fi

# make sure we are within the repository directory, otherwise guess it by the
# path of $0
REPOSITORY_BASE_PATH=$(readlink ${0%$BASE})

# change directory into the Fluter app base path
FLUTTER_APP_BASE_PATH=${REPOSITORY_BASE_PATH}/mobileapp
if [[ -xd ${FLUTTER_APP_BASE_APP} ]]
then
  cd ${FLUTTER_APP_BASE_APP}
  if [[ $? -ne 0 ]]
  then 
    echo "ERROR: Failed changing directory into ${FLUTTER_APP_BASE_APP}"
    exit 3
  fi
fi

# Generate the snap package
snapcraft
if [[ $? -ne 0]]
then
  echo "ERROR: Failed generating snap package"
  exit 4
fi

exit 0
