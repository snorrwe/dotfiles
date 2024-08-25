#!/usr/bin/env bash

(
cd .setup
bash setup.sh $@
)
rm -rf .git/hooks
ln -s $(pwd)/.githooks ./.git/hooks
