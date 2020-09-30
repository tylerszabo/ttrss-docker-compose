#!/bin/sh -e

DST_DIR=/backups
KEEP_DAYS=28

if pg_isready -h $DB_HOST -U $DB_USER; then
	DST_FILE=ttrss-backup-$(date +%Y%m%d).sql.gz

	echo backing up tt-rss database to $DST_DIR/$DST_FILE...

	export PGPASSWORD=$DB_PASS 

	pg_dump --clean -h $DB_HOST -U $DB_USER $DB_NAME | gzip > $DST_DIR/$DST_FILE

	echo cleaning up...

	find $DST_DIR -type f -name '*.sql.gz' -mtime +$KEEP_DAYS -delete

	echo done.
else
	echo backup failed: database is not ready.
fi
