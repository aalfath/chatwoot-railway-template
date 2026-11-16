# Changelog

## 4.19.1 (2026-11-16)

- First release of the template: Chatwoot v4.19.1 (`chatwoot/chatwoot:v4.19.1@sha256:a0d571a3a2f78f4fa4b1d7c21a53309c0184068d6021b3664ab37788faef04c1`), Postgres 16 with pgvector 0.8.7, Railway's Redis.
- Web server and Sidekiq run in one container that shares the `/app/storage` volume. `rails db:chatwoot_prepare` runs on every start.
