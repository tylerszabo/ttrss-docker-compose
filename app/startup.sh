#!/bin/sh -ex

OWNER=nobody
DST_DIR=/var/www/html/tt-rss
SRC_REPO=https://git.tt-rss.org/fox/tt-rss.git

export PGPASSWORD=$DB_PASS 

PSQL="psql -q -h $DB_HOST -U $DB_USER $DB_NAME"

if [ ! -d $DST_DIR ]; then
	mkdir -p $DST_DIR
	git clone $SRC_REPO $DST_DIR
else
	cd $DST_DIR && git pull origin master
fi

chown -R $OWNER $DST_DIR
chmod +x /etc/periodic/15min/*

for d in cache lock feed-icons; do
	chmod -R 777 $DST_DIR/$d
done

if ! $PSQL -c 'select * from ttrss_version'; then
	$PSQL < /var/www/html/tt-rss/schema/ttrss_schema_pgsql.sql
fi

if [ ! -s $DST_DIR/config.php ]; then
	SELF_URL_PATH=$(echo $SELF_URL_PATH | sed -e 's/[\/&]/\\&/g')

	sed \
		-e "s/define('DB_HOST'.*/define('DB_HOST','$DB_HOST');/" \
		-e "s/define('DB_USER'.*/define('DB_USER','$DB_USER');/" \
		-e "s/define('DB_NAME'.*/define('DB_NAME','$DB_NAME');/" \
		-e "s/define('DB_PASS'.*/define('DB_PASS','$DB_PASS');/" \
		-e "s/define('SELF_URL_PATH'.*/define('SELF_URL_PATH','$SELF_URL_PATH');/" \
		< $DST_DIR/config.php-dist > $DST_DIR/config.php
fi

crond &

exec /usr/sbin/php-fpm7 -F

