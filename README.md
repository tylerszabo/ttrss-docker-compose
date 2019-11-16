# A primitive set of scripts to deploy tt-rss via docker-compose

The idea is to provide tt-rss working (and updating) out of the box with minimal fuss.

Not fully tested yet, don't use in production unless you know what you're doing. Some features may not be implemented or broken, check the [TODO](https://git.tt-rss.org/fox/ttrss-docker-compose/wiki/TODO).

The general outline of the configuration is as follows:

 - three linked containers (frontend: caddy, database: pgsql, application: php/fpm)
 - caddy has its http port exposed to the outside
 - feed updating is done via embedded cron job, every 15 minutes
 - tt-rss source updates from git master repository on container restart
 - schema is installed automatically if it is missing
 - config.php is generated if it is missing
 - SSL termination not included, use a sidecar container for that (TODO)
 - tt-rss code is stored on a persistent volume so plugins, etc. could be easily added

### Installation

#### Check out scripts from Git:

```
git clone https://git.tt-rss.org/fox/ttrss-docker-compose.git ttrss-docker && cd ttrss-docker
```

#### Edit ``.env`` and/or ``docker-compose.yml`` if necessary

You will probably have to edit ``SELF_URL_PATH`` which should equal fully qualified tt-rss
URL as seen when opening it in your web browser. If this field is set incorrectly, you will
likely see the correct value in the tt-rss fatal error message.

#### Build and start the container

``docker-compose up``

See docker-compose documentation for more information and available options.

### Updating

Restarting the container will update tt-rss from the origin repository. If database needs to be updated,
tt-rss will prompt you to do so on next page refresh.

#### Updating container scripts

1. Stop the containers: ``docker-compose down && docker-compose rm``
2. Update scripts from git: ``git pull origin master`` and apply any necessary modifications to ``.env``, etc.
3. Rebuild and start the containers: ``docker-compose up --build``


### Using SSL with Letsencrypt (untested!)

 - ``HTTP_HOST`` in ``.env`` should be set to a valid hostname (i.e. no localhost or IP address)
 - comment out ``web`` container, uncomment ``web-ssl`` in ``docker-compose.yml``
 - ports 80 and 443 should be externally accessible i.e. not blocked by firewall and/or conflicting with host services

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

### How do I put this container behind a reverse proxy?

A common pattern is shared nginx doing SSL termination, etc.

```
   location /tt-rss/ {
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $remote_addr;
      proxy_set_header X-Forwarded-Proto $scheme;

      proxy_pass http://127.0.0.1:8280/tt-rss/;
      break;
   }
```

You will need to set ``SELF_URL_PATH`` to a correct (i.e. visible from the outside) value in ``config.php`` inside the container.

### TODO

- [wiki/TODO](https://git.tt-rss.org/fox/ttrss-docker-compose/wiki/TODO)
 	
### Suggestions / bug reports

- [Forum thread](https://community.tt-rss.org/t/docker-compose-tt-rss/2894)
