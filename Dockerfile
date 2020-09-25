FROM debian:jessie

ENV VIDEOBRIDGE_BUILDNUM="1132"

# These variables could be overridden to configure Prosody/ejabberd
ENV VIDEOBRIDGE_SECRET="password"
ENV XMPP_DOMAIN="mydomain.com"
ENV XMPP_SUBDOMAIN="videobridge1"
ENV XMPP_HOST="mydomain.com"
ENV XMPP_PORT="5347"
ENV APIS="rest,xmpp"
ENV MEDIA_MIN_PORT="40000"
ENV MEDIA_MAX_PORT="50000"

# Install videobridge and dependencies
USER root
RUN apt-get update && apt-get -y install \
wget \
unzip \
default-jre
RUN wget https://download.jitsi.org/jitsi-videobridge/linux/jitsi-videobridge-linux-x64-${VIDEOBRIDGE_BUILDNUM}.zip
RUN unzip jitsi-videobridge-linux-x64-${VIDEOBRIDGE_BUILDNUM}.zip

# Create videobridge user
RUN mkdir /jvb && \
groupadd -r jvb && \
useradd -r -g jvb -d /jvb -s /sbin/nologin -c "Jitsi Videobridge User" jvb && \
chown -R jvb:jvb /jvb

# Configure and run
USER jvb

ADD conf/sip-communicator.properties /jvb/.sip-connumicator/sip-communicator.properties
ADD scripts/run.sh /jvb/run.sh

EXPOSE 443 4443 $XMPP_PORT $MEDIA_MIN_PORT-$MEDIA_MAX_PORT

CMD ["/jvb/run.sh"]
