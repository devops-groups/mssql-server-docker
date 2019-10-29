FROM ubuntu:16.04
LABEL maintainer="DevOps Team"

ENV DEBIAN_FRONTEND noninteractive
ENV PATH $PATH:/opt/mssql/bin:/opt/mssql-tools/bin
ENV MSSQL_SERVER_VERSION 14.0.3238.1-19
ENV MSSQL_VOLUME_PATH /var/opt/mssql

RUN set -x \
    && apt-get update && apt-get install -y --no-install-recommends \
        apt-transport-https \
        apt-utils \
        ca-certificates \
        gnupg \
        curl \
        sudo \
        debconf \
        locales \
        libterm-readline-gnu-perl \
    && locale-gen en_US.UTF-8 \
    && /usr/sbin/update-locale LANG=en_US.UTF-8 \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-2017.list \
        | tee /etc/apt/sources.list.d/mssql-server-2017.list \
    && curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list \
        | tee /etc/apt/sources.list.d/msprod.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y --no-install-recommends \
        mssql-server=$MSSQL_SERVER_VERSION \
        mssql-tools \
    && echo 'mssql ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && echo "mssql soft stack 8192" >> /etc/security/limits.d/99-mssql-server.conf \
    && mkdir /docker-entrypoint-initdb.d \
    && chown -R mssql:mssql $MSSQL_VOLUME_PATH \
    && rm -rf /var/lib/apt/lists/*
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat

VOLUME $MSSQL_VOLUME_PATH
EXPOSE 1433
USER mssql
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sqlservr"]
