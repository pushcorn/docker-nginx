FROM pushcorn/ubuntu:latest

LABEL maintainer="joseph@pushcorn.com"

ARG NGINX_VERSION=*

RUN qd ubuntu:add-ppa-repo --user nginx --package stable \
    && apt-get -y install \
        nginx-light=$NGINX_VERSION \
        libnginx-mod-http-echo \
        libnginx-mod-http-headers-more-filter \
        libnginx-mod-http-upstream-fair \
        libnginx-mod-stream \
    \
    && rm -rf /var/lib/apt/lists/*

# RUN apt-get update \
    # && apt-get -y install \
        # software-properties-common \
    # && apt-add-repository -y ppa:nginx/stable \
    # && apt-get update \
    # && apt-get -y install \
        # nginx-light=$NGINX_VERSION \
        # libnginx-mod-http-echo \
        # libnginx-mod-http-headers-more-filter \
        # libnginx-mod-http-upstream-fair \
        # libnginx-mod-stream \
    # \
    # && apt-get -y remove software-properties-common \
    # && apt-get -y -f autoremove \
    # && rm -rf /var/lib/apt/lists/*

RUN mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.conf \
    && cd /etc/nginx/sites-enabled/ \
    && rm -f default \
    && ln -s ../sites-available/default.conf . \
    \
    && qd :install \
        --module watchman \
        --command render-template \
    && qd watchman:install \
    && rm -rf /tmp/*

COPY root/ /

EXPOSE 80 443

CMD ["nginx:start"]
