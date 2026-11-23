# WAHA (WhatsApp HTTP API) on Heroku — NOWEB engine (Baileys, no browser).
# The noweb image has no Chromium, so it stays light on a Heroku dyno.
FROM devlikeapro/waha:noweb
# WAHA reads $PORT (Heroku sets it) — see WAHA config docs ("for Heroku compatibility").
# Sessions MUST live in Postgres on Heroku (dyno disk is wiped on every restart):
# set WHATSAPP_SESSIONS_POSTGRESQL_URL in Config Vars (copy of DATABASE_URL).
