# A primitive set of scripts to deploy tt-rss via docker-compose

**EXPERIMENTAL STUFF, DON'T USE IN PRODUCTION**

The idea is to provide tt-rss working (and updating) out of the box
with minimal fuss.

The general outline of the configuration is as follows:

	- three linked containers (frontend: nginx, database: pgsql, application: php/fpm)
	- nginx has its http port exposed to the outside
	- feed updating is done via embedded cron job, every 15 minutes
	- tt-rss source updates from git master repository on container restart
	- schema is installed automatically if it is missing
	- config.php is generated if it is missing
	- SSL termination not included, you use a sidecar container for that
	- tt-rss code is exposed on a persistent volume so plugins, etc. could be easily added

Post your feedback here:

https://community.tt-rss.org/t/docker-compose-tt-rss/2894


### TODO

	- support for sending mail somehow (smtp mailer?)
	- properly deal with ``SELF_URL_PATH``
	
