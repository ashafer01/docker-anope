FROM ashafer01/ubuntu-base:18.04

COPY ashafer01-anope_*.deb /tmp/
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
