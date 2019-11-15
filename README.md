# A primitive set of scripts to deploy tt-rss via docker-compose

The idea is to provide tt-rss working (and updating) out of the box
with minimal fuss.

The general outline of the configuration is as follows:

- three linked containers (frontend: nginx, database: pgsql, application: php/fpm)
- nginx has its http port exposed to the outside
- feed updating is done via embedded cron job, every 15 minutes
- tt-rss source updates from git master repository on container restart
- schema is installed automatically on first startup
- SSL termination not included, you use a sidecar container for that

Post your feedback here:

https://community.tt-rss.org/t/docker-compose-tt-rss/2894

