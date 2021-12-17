#!/bin/bash
set -e

SUB_DIR=watchdog
SCRIPT_DIR=$(dirname $0)

EXPORT_ROOT=${1-$LAMASSU_EXPORT}

if [ -z "$EXPORT_ROOT" ]
  then
    echo "Builds a lamassu-machine package file for deploying to a device."
    echo -e "\nUsage:"
    echo -e "build <target directory>\n"
    echo "You may also set LAMASSU_EXPORT in lieu of <target directory>."
    exit 1
fi

EXPORT_BASE=$EXPORT_ROOT/$SUB_DIR
EXPORT_DIR=$EXPORT_BASE/package
MACHINE_DIR=$SCRIPT_DIR/../..
TARGET_MACHINE_DIR=$EXPORT_DIR/lamassu-machine
HARDWARE_DIR=$MACHINE_DIR/hardware/watchdog
UPDATESCRIPT=$SCRIPT_DIR/updateinit.js
TARGET_MODULES_DIR=$TARGET_MACHINE_DIR/node_modules
rm -rf $EXPORT_DIR
rm -rf $EXPORT_DIR
mkdir -p $EXPORT_DIR
mkdir -p $EXPORT_DIR
mkdir -p $TARGET_MACHINE_DIR

# Needed for updateinit script on target device
cp $MACHINE_DIR/node_modules/async/lib/async.js $EXPORT_DIR
cp $SCRIPT_DIR/../report.js $EXPORT_DIR
cp $UPDATESCRIPT $EXPORT_DIR/updatescript.js

# watchdog timeout change
cp $MACHINE_DIR/watchdog.js $EXPORT_DIR

git --git-dir=$MACHINE_DIR/.git rev-parse --short HEAD > $EXPORT_DIR/revision.txt
cat $EXPORT_DIR/revision.txt

node $SCRIPT_DIR/../build.js $EXPORT_BASE
