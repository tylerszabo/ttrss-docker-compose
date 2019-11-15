# A primitive set of scripts to deploy tt-rss via docker-compose

**EXPERIMENTAL STUFF, DON'T USE IN PRODUCTION YET**

The idea is to provide tt-rss working (and updating) out of the box
with minimal fuss.

The general outline of the configuration is as follows:

 - three linked containers (frontend: nginx, database: pgsql, application: php/fpm)
 - nginx has its http port exposed to the outside
 - feed updating is done via embedded cron job, every 15 minutes
 - tt-rss source updates from git master repository on container restart
 - schema is installed automatically if it is missing
 - config.php is generated if it is missing
 - SSL termination not included, use a sidecar container for that (TODO)
 - tt-rss code is stored on a persistent volume so plugins, etc. could be easily added

Post your feedback here:

https://community.tt-rss.org/t/docker-compose-tt-rss/2894

### Installation

1. Check out scripts from Git:

```
git clone https://git.tt-rss.org/fox/ttrss-docker-compose.git ttrss-docker
```

2. Edit ``.env`` and/or ``docker-compose.yml`` if necessary

You will probably have to edit ``SELF_URL_PATH`` which should equal fully qualified tt-rss
URL as seen when opening it in your web browser. If this field is set incorrectly, you will
likely see the correct value in the tt-rss fatal error message.

3. Run the container:

```
cd ttrss-docker && docker-compose up
```

See docker-compose documentation for more information and available options.

### Updating

Restarting the container will update the source from origin repository. If database needs to be updated,
tt-rss will prompt you to do so on next page refresh.

### How do I add plugins and themes?

By default, tt-rss code is stored on a persistent docker volume (``app``). You can find
its location like this: 

``docker volume inspect ttrss-docker_app | grep Mountpoint``

Alternatively, you can mount any host directory as ``/var/www/html`` by updating ``docker-compose.yml``, i.e.:

```
volumes:
      - app:/var/www/html
```

Replace with:

```
volumes:
      - /opt/tt-rss:/var/www/html
```

Copy and/or git clone any third party plugins into ``plugins.local`` as usual.

### TODO

 - support for sending mail somehow (smtp mailer?)
 - properly deal with ``SELF_URL_PATH``
	
### Feedback / suggestions2

[Forum thread](https://community.tt-rss.org/t/docker-compose-tt-rss/2894)