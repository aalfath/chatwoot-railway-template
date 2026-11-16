# Chatwoot for Railway: the official image, pinned by version and digest,
# plus a start script that runs the web server and the Sidekiq worker together.
FROM chatwoot/chatwoot:v4.19.1@sha256:a0d571a3a2f78f4fa4b1d7c21a53309c0184068d6021b3664ab37788faef04c1

ENV RAILS_ENV=production \
    NODE_ENV=production \
    INSTALLATION_ENV=docker \
    RAILS_LOG_TO_STDOUT=true

COPY --chmod=755 railway-start.sh /usr/local/bin/railway-start.sh

WORKDIR /app
ENTRYPOINT []
CMD ["/usr/local/bin/railway-start.sh"]
