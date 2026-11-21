[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/chatwoot-5?utm_medium=integration&utm_source=button&utm_campaign=chatwoot)

# Chatwoot on Railway

A Railway template for [Chatwoot](https://www.chatwoot.com), the open-source customer support platform (shared inbox for website live chat, email, WhatsApp, Telegram, Facebook, Instagram and more).

## What the template deploys

| Service | Source | Notes |
|---|---|---|
| **Chatwoot** | this repo (`Dockerfile`) | `chatwoot/chatwoot:v4.20.1`, pinned by digest. Runs the Rails web server and the Sidekiq worker in one container. Public domain, health check `/api`, volume at `/app/storage` for uploads |
| **Postgres** | `pgvector/pgvector:0.8.7-pg16` (pinned by digest) | Chatwoot 4 needs the `vector` extension. Volume at `/var/lib/postgresql/data` |
| **Redis** | Railway's Redis | Jobs, caching and real-time events |

On every start, `railway-start.sh` waits for Postgres, runs `rails db:chatwoot_prepare` (creates the database on the first boot, runs migrations after an update), then starts Puma and Sidekiq. If either process stops, the container exits and Railway restarts it.

Why web and worker share one service: with local file storage both processes must see the same `/app/storage`, and a Railway volume attaches to one service only.

## Variables

Set by the template, no prompts:

| Variable | Value |
|---|---|
| `SECRET_KEY_BASE` | generated secret |
| `FRONTEND_URL` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` |
| `DATABASE_URL` | `${{Postgres.DATABASE_URL}}` |
| `REDIS_URL` | `${{Redis.REDIS_URL}}` |
| `PORT` | `3000` |

Defaults baked into the start script, which you can override with a service variable: `ACTIVE_STORAGE_SERVICE=local`, `ENABLE_ACCOUNT_SIGNUP=false`, `FORCE_SSL=false` (Railway's edge already serves HTTPS), `LOG_LEVEL=info`.

Optional, add them on the Chatwoot service when you need them (see [Chatwoot's environment variables](https://www.chatwoot.com/docs/self-hosted/configuration/environment-variables)):

- Email: `SMTP_ADDRESS`, `SMTP_PORT`, `SMTP_USERNAME`, `SMTP_PASSWORD`, `SMTP_AUTHENTICATION`, `SMTP_DOMAIN`, `MAILER_SENDER_EMAIL`. Without SMTP, Chatwoot can't send invitations, password resets or email notifications.
- Channels: Facebook/Instagram (`FB_*`, `IG_VERIFY_TOKEN`), Slack (`SLACK_*`), Google and Microsoft email (`GOOGLE_OAUTH_*`, `AZURE_APP_*`), and inbound email (`RAILS_INBOUND_EMAIL_*`, `MAILER_INBOUND_EMAIL_DOMAIN`).
- S3-compatible storage instead of the volume: `ACTIVE_STORAGE_SERVICE=s3_compatible` plus the `STORAGE_*` variables.

## First run

Open the public URL right after the deploy finishes. Chatwoot shows its installation page, where you create the first administrator account. Do it straight away: until then, anyone who opens the URL can create it. Public sign-up stays off (`ENABLE_ACCOUNT_SIGNUP=false`); invite agents from the dashboard.

## Updates

The template builds from this repo's `main` branch. When a new Chatwoot release is pinned here, Railway shows an "update available" notice in projects deployed from the template, and you choose when to apply it. Read [CHANGELOG.md](CHANGELOG.md) first. Database migrations run on the next start. Back up Postgres before major upgrades.

## Local test

```sh
docker build -t chatwoot-railway .
```

Run it with the variables above, a `pgvector/pgvector:pg16` database and Redis.
