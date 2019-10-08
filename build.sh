#!/bin/bash
set -e

cd /tmp/build

# get the latest anope source
wget "https://github.com/anope/anope/releases/download/$ANOPE_VERSION/anope-$ANOPE_VERSION-source.tar.gz"
tar -xzvf "anope-$ANOPE_VERSION-source.tar.gz"
cd "anope-$ANOPE_VERSION-source"

# configure the build
mv /tmp/build/config.cache .
./Config -quick
cd build

# build source
make
make install

# build deb

cd /tmp/deb
find /opt/anope/conf -type f > DEBIAN/conffiles
find /opt/anope -type f -printf '%p ' | xargs md5sum > DEBIAN/md5sums
mkdir opt
cp -a /opt/anope opt/

dpkg -b /tmp/deb/ "/tmp/artifacts/ashafer01-anope_$ANOPE_VERSION.deb"
