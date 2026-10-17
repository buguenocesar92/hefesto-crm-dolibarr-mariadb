FROM dolibarr/dolibarr:24.0.1@sha256:638727a1a035515b8f1e9c7694ee25315c4b79d618d4f19878efda977b20d49f
ENV DOLI_VERSION=24.0.2
ARG SOURCE_COMMIT=7e927764767343334aaa067ca5ec054cfea0a26b
ARG SOURCE_SHA256=5aa6b22914768457b647cd6a77a3807df02d3e33220617922f850768249cd641
USER root
RUN curl -fL "https://codeload.github.com/Dolibarr/dolibarr/tar.gz/${SOURCE_COMMIT}" -o /tmp/source.tgz \
 && echo "${SOURCE_SHA256}  /tmp/source.tgz" | sha256sum -c - \
 && mkdir /tmp/source && tar -xzf /tmp/source.tgz --strip-components=1 -C /tmp/source \
 && cp /var/www/scripts/docker-init.php /tmp/docker-init.php \
 && rm -rf /var/www/html /var/www/scripts \
 && mkdir -p /var/www/html \
 && cp -a /tmp/source/htdocs/. /var/www/html/ \
 && cp -a /tmp/source/scripts /var/www/scripts \
 && cp /tmp/docker-init.php /var/www/scripts/docker-init.php \
 && mkdir -p /var/www/html/custom /var/www/scripts/docker-init.d \
 && chown -R www-data:www-data /var/www/html /var/www/scripts \
 && chmod -R u-w /var/www/html \
 && sed -i 's/Set cron key to ${DOLI_CRON_KEY}/Set cron key (redacted)/g' /usr/local/bin/docker-run.sh \
 && rm -rf /tmp/source /tmp/source.tgz /tmp/docker-init.php
COPY container/ /opt/hefesto/
COPY container/initialize.php /var/www/scripts/docker-init.d/90-hefesto.php
RUN php -l /opt/hefesto/health.php && php -l /opt/hefesto/initialize.php
