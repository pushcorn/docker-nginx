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
    && qd ubuntu:end-apt-install

RUN mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.conf \
    && cd /etc/nginx/sites-enabled/ \
    && rm -f default \
    && ln -s ../sites-available/default.conf . \
    && cp /usr/share/nginx/modules-available/* /etc/nginx/modules-available/ \
    && cd /etc/nginx/modules-enabled/ \
    && rm -f ./* \
    && ln -s ../modules-available/mod-http-echo.conf . \
    && ln -s ../modules-available/mod-http-headers-more-filter.conf . \
    && ln -s ../modules-available/mod-http-upstream-fair.conf . \
    && ln -s ../modules-available/mod-stream.conf . \
    && mv /var/www/html/index.nginx-debian.html /var/www/html/index.html \
    \
    && qd :install \
        --command openssl:create-cert \
        --command render-template \
        --module watchman \
    && qd watchman:install \
    && rm -rf /tmp/*

COPY root/ /

EXPOSE 80 443

CMD ["nginx:start"]
