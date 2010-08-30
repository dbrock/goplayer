#!/bin/sh

if [ "x$ASSPEC_SRC" == x ] ; then
  echo 'Please set $ASSPEC_SRC to the source directory of ASSpec:'
  echo '  git clone git://github.com/dbrock/asspec.git ~/asspec'
  echo '  export ASSPEC_SRC=~/asspec/source'
  exit -1
fi
  
asautotest src/goplayer.as -o bin/goplayer.swf -I skin-interface \
   -- src/goplayer_spec.as --test --asspec-adapter-source -I "$ASSPEC_SRC" \
   --- --static-typing
