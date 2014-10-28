#!/bin/bash

set -xe

DOCKER="docker -H tcp://localhost:4243"

$DOCKER run --name llvm-git-build \
  -i -t \
  -v $PWD/llvm:/src/llvm \
  -v $PWD/clang:/src/clang \
  -v $PWD/compiler-rt:/src/compiler-rt \
  -v $PWD/poolalloc:/src/poolalloc \
  \
  wdtz/llvm-git-base /bin/bash << EOF
mkdir -p /llvm/build
ln -sf /src/llvm /llvm/src
ln -sf /src/clang /llvm/src/tools/
ln -sf /src/compiler-rt /llvm/src/projects/
ln -sf /src/poolalloc /llvm/src/projects/

cd /llvm/build
/llvm/src/configure --enable-optimized --prefix=/llvm/install
make -j$(nproc)
make check
make check -C /llvm/build/projects/poolalloc
make install
EOF

$DOCKER logs -f llvm-git-build
$DOCKER wait llvm-git-build
$DOCKER commit llvm-git-build wdtz/llvm-git
$DOCKER rm llvm-git-build
