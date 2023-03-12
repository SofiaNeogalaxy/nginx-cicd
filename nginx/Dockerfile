FROM nginx:latest

RUN mkdir /etc/nginx/private /etc/nginx/certs
COPY nginx/static-web/index* /etc/nginx/html/
COPY nginx/static-web/nginx.conf /etc/nginx/

RUN openssl req -x509 -nodes -days 365 \
-subj "/C=US/ST=FL/O=kelvin DevOps, LLC/CN=127.0.0.1" \
-newkey rsa:2048 -keyout /etc/nginx/private/nginx-selfsigned.key \
-out /etc/nginx/certs/nginx-selfsigned.crt;