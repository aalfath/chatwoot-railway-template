# Chatwoot for Railway: the official image, pinned by version and digest,
# plus a start script that runs the web server and the Sidekiq worker together.
FROM chatwoot/chatwoot:v4.20.0@sha256:224bac350a1a627120ac6500d6b6d509cbd3ef9bb57803bb935c631b47555836

ENV RAILS_ENV=production \
    NODE_ENV=production \
    INSTALLATION_ENV=docker \
    RAILS_LOG_TO_STDOUT=true

COPY --chmod=755 railway-start.sh /usr/local/bin/railway-start.sh

WORKDIR /app
ENTRYPOINT []
CMD ["/usr/local/bin/railway-start.sh"]
