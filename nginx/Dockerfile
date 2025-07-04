ARG NGINX_IMAGE

FROM ${NGINX_IMAGE}

# insert server_tokens off; to /etc/nginx/nginx.conf
RUN head -n -5 /etc/nginx/nginx.conf >  /tmp/nginx.conf; \
    echo '    server_tokens off;'    >> /tmp/nginx.conf; \
    tail -n 5  /etc/nginx/nginx.conf >> /tmp/nginx.conf; \
    mv /tmp/nginx.conf /etc/nginx/nginx.conf