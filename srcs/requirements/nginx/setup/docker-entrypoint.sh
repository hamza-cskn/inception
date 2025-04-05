if [ -f /etc/ssl/ssl.key ] && [ -f /etc/ssl/ssl.crt ]; then
    echo "SSL key and certificate found. Using existing files."
else
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/ssl/ssl.key \
        -out /etc/ssl/ssl.crt \
        -subj "/CN=hcoskun"
fi

exec $@