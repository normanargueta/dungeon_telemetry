import Config

config :dungeon_telemetry, DungeonTelemetryWeb.Endpoint,
  adapter: Bandit.PhoenixAdapter,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  server: true,
  # Local-development placeholder. The app does not use sessions or signed
  # cookies; set a real value (e.g. via SECRET_KEY_BASE) before deploying.
  secret_key_base: System.get_env("SECRET_KEY_BASE", String.duplicate("a", 64))
