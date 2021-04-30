FROM pushcorn/ubuntu:20.04

LABEL maintainer="joseph@pushcorn.com"

ARG NGINX_VERSION=1.18.*

RUN qd ubuntu:begin-apt-install \
    && qd ubuntu:add-ppa-repo --package nginx/stable \
    && apt-get -y install \
        nginx-light=$NGINX_VERSION \
        libnginx-mod-http-echo \
        libnginx-mod-http-headers-more-filter \
        libnginx-mod-http-upstream-fair \
        libnginx-mod-stream \
    && qd ubuntu:end-apt-install \
    \
    mv /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default.conf \
    && rm /etc/nginx/sites-enabled/default \
    && mv /var/www/html/index.nginx-debian.html /var/www/html/index.html \
    \
    && qd :install --module openssl --prefix /usr/local

EXPOSE 80 443

CMD [":run-task", "--task", "start,nginx:start"]
