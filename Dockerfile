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

COPY .qd /root/.qd

RUN mv /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default.conf \
    && rm /etc/nginx/sites-enabled/default \
    && mv /var/www/html/index.nginx-debian.html /var/www/html/index.html \
    \
    && qd :install \
        --command openssl:create-cert \
        --command render-template \
        --module watchman \
    && qd watchman:install \
    && touch /etc/nginx/.first-time \
    && rm -rf /tmp/*

EXPOSE 80 443

CMD [":run-task", "--task", "nginx:start"]
