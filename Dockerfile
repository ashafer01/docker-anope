##
## build
##
FROM ashafer01/ubuntu-base:18.04 AS build

ENV ANOPE_VERSION=2.0.6

RUN apt-get -y update && apt-get -y install \
    cmake \
    build-essential \
    wget

RUN mkdir -p /opt/anope /tmp/build /tmp/deb /tmp/artifacts \
 && chown irc:irc /opt/anope /tmp/build /tmp/deb /tmp/artifacts

USER irc:irc
COPY --chown=irc:irc config.cache build.sh /tmp/build/
COPY --chown=irc:irc deb-skel/ /tmp/deb/
WORKDIR /tmp

RUN /tmp/build/build.sh
LABEL stage=anope-build

##
## production
##
FROM ashafer01/ubuntu-base:18.04

COPY --from=build /tmp/artifacts/ashafer01-anope_*.deb /tmp/
RUN apt-get -y update && apt-get -y install /tmp/ashafer01-anope_*.deb

# TODO copy in default configs
# TODO write default configs

# clean up
RUN rm -f /tmp/ashafer01-anope_*.deb \
 && apt-get -y clean \
 && apt-get -y autoclean \
 && apt-get -y autoremove

VOLUME /opt/anope/conf
VOLUME /opt/anope/data
VOLUME /opt/anope/logs

# start anope
USER irc:irc
CMD ["/opt/anope/bin/services", "-n"]
