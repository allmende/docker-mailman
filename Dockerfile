FROM debian:jessie

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y nginx mailman postfix supervisor fcgiwrap multiwatch busybox-syslogd && \
    apt-get -y install vim && \
    rm -rf /var/lib/apt/lists/* && \
    # Cache default dirs as template
    cp -a /etc/mailman /etc/mailman.cache && \
    cp -a /var/lib/mailman /var/lib/mailman.cache && \
    cp -a /var/spool/postfix /var/spool/postfix.cache && \
    # Configure Nginx
    sed -i -e 's@worker_processes 4@worker_processes 1@g' /etc/nginx/nginx.conf && \
    rm -f /etc/nginx/sites-enabled/default

ADD nginx.conf /etc/nginx/conf.d/
ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD *.sh /

EXPOSE 25 80

#VOLUME ["/etc/mailman/", "/var/lib/mailman", "/var/log/mailman", "/var/spool/postfix"]

ENTRYPOINT ["/entry.sh"]

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
