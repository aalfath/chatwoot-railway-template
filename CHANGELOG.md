# Changelog

## 4.20.0 (2026-11-19)

- No breaking changes for this template. Conversations, contacts and settings in Postgres and files on the `/app/storage` volume are kept; `rails db:chatwoot_prepare` runs the new migrations at start. If you use a **Bandwidth** inbox: Bandwidth retires legacy API-user authentication on 2026-12-02, so switch that inbox to OAuth client credentials (Chatwoot's release notes link the guide).
- Chatwoot [v4.20.0](https://github.com/chatwoot/chatwoot/releases/tag/v4.20.0): upstream recommends it for 30+ security fixes and hardening across authentication, webhooks, APIs, data access and dependencies.
- Image: `chatwoot/chatwoot:v4.20.0@sha256:224bac350a1a627120ac6500d6b6d509cbd3ef9bb57803bb935c631b47555836`.

## Unreleased

- README: add the Deploy on Railway button for the published template (`chatwoot-5`). No change to the image or the start script.

## 4.19.1 (2026-11-16)

- First release of the template: Chatwoot v4.19.1 (`chatwoot/chatwoot:v4.19.1@sha256:a0d571a3a2f78f4fa4b1d7c21a53309c0184068d6021b3664ab37788faef04c1`), Postgres 16 with pgvector 0.8.7, Railway's Redis.
- Web server and Sidekiq run in one container that shares the `/app/storage` volume. `rails db:chatwoot_prepare` runs on every start.
