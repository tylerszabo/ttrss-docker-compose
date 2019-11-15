FROM alpine:3.9
EXPOSE 9000/tcp

RUN apk add --no-cache php7 php7-fpm \
	php7-pdo php7-gd php7-pgsql php7-pdo_pgsql php7-mbstring \
	php7-intl php7-xml php7-curl php7-session \
	php7-dom php7-fileinfo php7-json \
	git postgresql-client dcron sudo

ADD startup.sh /
ADD scripts/update /etc/periodic/15min/

RUN sed -i.bak 's/^listen = 127.0.0.1:9000/listen = 9000/' /etc/php7/php-fpm.d/www.conf

CMD /startup.sh
