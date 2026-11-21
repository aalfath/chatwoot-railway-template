# Chatwoot for Railway: the official image, pinned by version and digest,
# plus a start script that runs the web server and the Sidekiq worker together.
FROM chatwoot/chatwoot:v4.20.1@sha256:49cf2b0dbbe5610417769bee15ae8a7d0474eab331ea8dbd9f3aae06d07b42cb

ENV RAILS_ENV=production \
    NODE_ENV=production \
    INSTALLATION_ENV=docker \
    RAILS_LOG_TO_STDOUT=true

COPY --chmod=755 railway-start.sh /usr/local/bin/railway-start.sh

WORKDIR /app
ENTRYPOINT []
CMD ["/usr/local/bin/railway-start.sh"]
