FROM debian:stable-20250224-slim

WORKDIR /app

RUN apt update
RUN apt install -y nginx
RUN apt install -y openssl

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD [ "nginx", "-c", "/etc/nginx/hcoskun-config/nginx.conf", "-g", "daemon off;" ]