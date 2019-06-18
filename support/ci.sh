#! /bin/sh

set -uex

janetver="9c89d1c658a11a40c4a97bd88a9321382c26fda5"
janeturl="https://github.com/janet-lang/janet/archive/${janetver}.tar.gz"
mkdir -p ci_builds
prefix="$(readlink -f ./ci_builds)/installed"
mkdir -p "$prefix"
cd ci_builds
curl "$janeturl" -L -o ./janet.tar.gz
tar xzf ./janet.tar.gz
cd "janet-${janetver}"
meson . meson --prefix="$prefix"
cd meson
ninja install
cd ../../../
./configure --prefix="$prefix" --janet-header-cflags="-I$(readlink -f ./ci_builds/janet-${janetver}/src/include)" --with-readnoise
make install
export PATH="$prefix/bin:$PATH"
./test/runner
