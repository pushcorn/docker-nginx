FROM pushcorn/ubuntu:latest

LABEL maintainer="joseph@pushcorn.com"

ARG NGINX_VERSION=*

RUN qd ubuntu:begin-apt-install \
    && qd ubuntu:add-ppa-repo --package nginx/stable \
    && apt-get -y install \
        nginx-light=$NGINX_VERSION \
        libnginx-mod-http-echo \
        libnginx-mod-http-headers-more-filter \
        libnginx-mod-http-upstream-fair \
        libnginx-mod-stream \
    \
    && qd ubuntu:end-apt-install

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
