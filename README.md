# WAHA on Heroku

[WAHA](https://github.com/devlikeapro/waha) (WhatsApp HTTP API) running on Heroku,
with the **NOWEB** engine (Baileys — no browser needed, and the only engines
that support Channels are NOWEB and GOWS).

Use it to react to channel posts over a plain HTTP call:

```bash
curl -X PUT https://YOUR-APP.herokuapp.com/api/reaction \
  -H "X-Api-Key: YOUR_WAHA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "session": "default",
    "messageId": "false_11111111111@newsletter_100_AAAAAAAAAAAAAAAAAAAA",
    "reaction": "❤️"
  }'
```

Get a post's `messageId` from the channel preview endpoint:

```
GET /api/default/channels/{invite}/messages/preview?limit=100
```

(The `messageId` formats are documented in the
[WAHA Channels docs](https://waha.devlike.pro/docs/how-to/channels/#send-reaction-to-the-channel).)

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/SY3D-ME3R/WAHA-HEROKU)

## Deploy

1. Click **Deploy to Heroku** above (or create the app from this repo yourself).
2. Heroku attaches **Postgres** and **Redis** add-ons (listed in `app.json`).
   If an add-on plan name is rejected, attach the cheapest Postgres and Redis
   from the app's **Resources** tab instead.
3. **Important — sessions must live in Postgres.** Heroku dynos wipe their
   local disk on every restart, so a session stored on disk would be lost and
   you would have to re-scan the QR code after each restart. In **Settings →
   Config Vars** set:
   - `WHATSAPP_SESSIONS_POSTGRESQL_URL` = the value of `DATABASE_URL`
     (the Postgres add-on sets `DATABASE_URL` automatically — copy its value).
   Then restart the dynos once.
4. **Dyno type:** use **Basic ($7/mo) or higher**. Eco dynos sleep after
   30 minutes of inactivity, which disconnects the WhatsApp session.
   Heroku is not free: roughly $7 (dyno) + $5 (Postgres Essential) + $5
   (Redis Mini) per month.
5. Open the app URL → WAHA dashboard → create a session named `default` →
   scan the QR code with the WhatsApp number you want to react from.

## How it works

- `Dockerfile` uses the official image `devlikeapro/waha:noweb`.
- `heroku.yml` deploys it on Heroku's container stack.
- WAHA reads `$PORT` (Heroku sets it) — its own config docs note this is
  "for Heroku compatibility".
- `WHATSAPP_DEFAULT_ENGINE=NOWEB` — Baileys over WebSocket, no Chromium.

## Warnings

- WAHA is an **unofficial** WhatsApp client (not Meta's official API).
  Use a spare number, keep the pace human, never spam — WhatsApp can ban
  numbers that automate aggressively.
- Never put `WAHA_API_KEY` or any secret in this repo. It is generated at
  deploy time and lives only in Heroku Config Vars.
