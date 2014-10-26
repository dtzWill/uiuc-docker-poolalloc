# Docker container image for building apps hosted on LLVM.

FROM       ubuntu:utopic
MAINTAINER Will Dietz <w@wdtz.org>

# Prefer local UIUC mirror (cosmos):
RUN sed -i.docker.orig /etc/apt/sources.list \
	-e 's@http://archive\.ubuntu\.com/ubuntu@http://cosmos.cites.illinois.edu/pub/ubuntu@'

# Update and install dependencies
RUN apt-get update -qq -y
RUN apt-get install -qq -y wget build-essential cmake python ninja vim-nox git subversion groff

# Grab all source
RUN mkdir -p /llvm /llvm/build && \
	git clone git://github.com/llvm-mirror/llvm.git /llvm/src && \
	git clone git://github.com/llvm-mirror/clang.git /llvm/src/tools/clang && \
	git clone git://github.com/llvm-mirror/compiler-rt.git /llvm/src/projects/compiler-rt && \
	git clone git://github.com/llvm-mirror/poolalloc.git /llvm/src/projects/poolalloc

# (Use autotools+make for now, since poolalloc+cmake don't work presently)

# Configure
WORKDIR /llvm/build
RUN /llvm/src/configure --enable-optimized --prefix=/llvm/install

# Build
RUN make -j`nproc`

# Test
RUN make check
# Directly run poolalloc tests, ensure they're executed:
# XXX: Check if poolalloc tests are run as part of above or no.
RUN make check -C /llvm/build/projects/poolalloc

# Install
RUN make install
