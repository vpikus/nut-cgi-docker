FROM debian:bullseye-slim

RUN apt-get update; \
    apt-get install --no-install-recommends --yes \
	lighttpd \
	nut-cgi; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;

# Should be mounted externally
RUN rm /etc/nut/hosts.conf

EXPOSE 80

RUN rm -f /etc/lighttpd/conf-enabled/*-unconfigured.conf && \
    ln -s /etc/lighttpd/conf-available/*-accesslog.conf /etc/lighttpd/conf-enabled/ && \
    ln -s /etc/lighttpd/conf-available/*-cgi.conf /etc/lighttpd/conf-enabled/

RUN sed -i 's|/cgi-bin/|/|g' /etc/lighttpd/conf-enabled/*-cgi.conf && \
    sed -i 's|^\(server.document-root.*=\).*|\1 "/usr/lib/cgi-bin/nut"|g' /etc/lighttpd/lighttpd.conf && \
    sed -i 's|^\(index-file.names.*=\).*|\1 ( "upsstats.cgi" )|g' /etc/lighttpd/lighttpd.conf && \
    sed -i '/alias.url/d' /etc/lighttpd/conf-enabled/*-cgi.conf

# Configure non root user
RUN groupadd -r webnut && useradd --no-log-init -r -g webnut webnut
RUN chown -R webnut:webnut /var/www /var/log/lighttpd

RUN mkdir -p /var/run/lighttpd && chown -R webnut:webnut /var/run/lighttpd
RUN sed -i 's|^\(server.pid-file.*=\).*|\1 "/var/run/lighttpd/lighttpd.pid"|g' /etc/lighttpd/lighttpd.conf

USER webnut

CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
