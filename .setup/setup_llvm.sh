#!/usr/bin/bash

set -ex

sudo apt-get install -y \
    clang-format \
    clang-tidy \
    clang-tools \
    clang \
    clangd \
    libc++-dev \
    libc++1 \
    libc++abi-dev \
    libc++abi1 \
    libclang-dev \
    libclang1 \
    liblldb-dev \
    libomp-dev \
    libomp5 \
    lld \
    lldb \
    llvm-dev \
    llvm-runtime \
    llvm \
    python3-clang
