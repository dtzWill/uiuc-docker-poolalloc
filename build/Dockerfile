FROM wdtz/llvm-git-base
MAINTAINER Will Dietz <w@wdtz.org>

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

