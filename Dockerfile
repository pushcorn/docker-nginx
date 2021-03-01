FROM pushcorn/ubuntu:latest

LABEL maintainer="joseph@pushcorn.com"

ARG NGINX_VERSION=*

RUN apt-get update \
    && apt-get -y install \
        software-properties-common \
    && apt-add-repository -y ppa:nginx/stable \
    && apt-get update \
    && apt-get -y install \
        nginx-light=$NGINX_VERSION \
        libnginx-mod-http-echo \
        libnginx-mod-http-headers-more-filter \
        libnginx-mod-http-upstream-fair \
        libnginx-mod-stream \
    \
    && apt-get -y remove software-properties-common \
    && apt-get -y -f autoremove \
    && rm -rf /var/lib/apt/lists/* \
    \
    && cd /etc \
        && tar cfz nginx.tgz nginx \
    \
    && mkdir /tmp/qd \
        && cd /tmp/qd \
        && curl -sLO https://bitbucket.org/josephtzeng/quick-and-dirty/get/master.tar.gz \
        && tar xfz master.tar.gz \
        && cd $(ls) \
        && mkdir -p ~/.qd/modules \
        && mv modules/watchman ~/.qd/modules/ \
        && qd watchman:install \
        && rm -rf /tmp/*

COPY root/ /

EXPOSE 80 443

CMD ["qd", "nginx:start"]
