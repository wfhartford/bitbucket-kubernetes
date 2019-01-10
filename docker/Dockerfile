FROM azul/zulu-openjdk-alpine:11.0.1

ARG DOWNLOAD_MIRROR=https://downloads.atlassian.com

ENV JAVA_HOME=/usr/lib/jvm/zulu11.2.3-jdk11.0.1-linux_musl_x64
ENV BBS_VERSION=5.15.1
ENV BITBUCKET_HOME=/bitbucket-home

RUN apk --no-cache add bash git perl tini && \
    mkdir /bitbucket && \
    wget -q -O - ${DOWNLOAD_MIRROR}/software/stash/downloads/atlassian-bitbucket-${BBS_VERSION}.tar.gz \
        | tar -zx --strip-components=1 -C /bitbucket && \
    rm -rf /bitbucket/elasticsearch && \
    mkdir -p /bitbucket-home/shared /config && \
    ln -s /config/bitbucket.properties /bitbucket-home/shared/bitbucket.properties

COPY bitbucket.properties /config/
COPY start.sh /

VOLUME /bitbucket-home
VOLUME /config

EXPOSE 7990 7999

ENTRYPOINT ["/sbin/tini", "--"]
CMD /start.sh
