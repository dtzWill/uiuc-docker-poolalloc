# Base image for building llvm w/poolalloc, clang, compiler-rt

FROM       ubuntu:utopic
MAINTAINER Will Dietz <w@wdtz.org>

VOLUME ["/src/llvm","/src/clang","/src/compiler-rt","/src/poolalloc"]

# Prefer local UIUC mirror (cosmos),
# Install dependencies,
# Create directory structure for mounting source volumes.
RUN sed -i.docker.orig /etc/apt/sources.list \
      -e 's@http://archive\.ubuntu\.com/ubuntu@http://cosmos.cites.illinois.edu/pub/ubuntu@' && \
    apt-get update -qq -y && \
    apt-get install -qq -y wget build-essential cmake python ninja vim-nox git subversion groff

