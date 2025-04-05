FROM debian:stable-20250224-slim

WORKDIR /app

RUN apt update
RUN apt install -y nginx
RUN apt install -y openssl

RUN mkdir -p /etc/nginx/hcoskun-config

EXPOSE 443

STOPSIGNAL SIGQUIT

ENTRYPOINT [ "./setup/docker-entrypoint.sh" ]

CMD [ "nginx", "-c", "/etc/nginx/hcoskun-config/nginx.conf", "-g", "daemon off;" ]