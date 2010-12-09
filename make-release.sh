#!/bin/bash

set -o errexit

target=releases/goplayer-$1

git tag v$1
mkdir $target
cp releases/template/* $target
cp bin/goplayer.swf js-src/* $target
mkdir $target/alternate-skins
cp skins/*.swf $target/alternate-skins
cp skins/goplayer-white-skin.swf $target/goplayer-skin.swf

cd releases
zip -r goplayer-$1.zip goplayer-$1
