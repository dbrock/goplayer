#!/bin/sh

if [ x$ASSPEC_SRC = x ] ; then
  echo 'Please set $ASSPEC_SRC to the source directory of ASSpec:'
  echo '  cd ~'
  echo '  git clone git@github.com:dbrock/asspec.git'
  echo '  export ASSPEC_SRC=~/asspec/source'
  exit -1
fi

# Loop because asautotest sometimes crashes.
while true ; do
  asautotest src/goplayer.as src "$ASSPEC_SRC" \
    --static-typing -o bin/goplayer.swf
done
