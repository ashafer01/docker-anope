FROM ashafer01/ubuntu-base:18.04

ENV ANOPE_VERSION=2.0.6

# basic deps beyond ashafer01/ubuntu-base
RUN apt-get -y update && apt-get -y install cmake

# get the latest anope source
WORKDIR /root/dockerbuild
ADD https://github.com/anope/anope/releases/download/$ANOPE_VERSION/anope-$ANOPE_VERSION-source.tar.gz .
RUN tar -xzvf anope-$ANOPE_VERSION-source.tar.gz && mkdir -p /opt/anope

# configure the build
WORKDIR anope-$ANOPE_VERSION-source
COPY config.cache .
RUN ./Config -quick

# Run the build
WORKDIR build
RUN make && make install

# clean up
WORKDIR /opt/anope
RUN chown -R irc:irc /opt/anope && rm -rf /root/dockerbuild

VOLUME /opt/anope/conf
VOLUME /opt/anope/data
VOLUME /opt/anope/logs

# start anope
USER irc:irc
CMD ["/opt/anope/bin/services", "-n"]
