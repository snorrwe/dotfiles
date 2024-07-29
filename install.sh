#!/usr/bin/env bash

set -e

pushd .setup
trap popd EXIT
bash setup.sh
