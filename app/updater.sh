#!/bin/sh -ex

while ! pg_isready -h $DB_HOST -U $DB_USER; do
	echo waiting until $DB_HOST is ready...
	sleep 3
done

DST_DIR=/var/www/html/tt-rss

while [ ! -s $DST_DIR/config.php ]; do
	echo waiting for $DST_DIR/config.php...
	sleep 3
done

exec /usr/bin/php /var/www/html/tt-rss/update_daemon2.php
