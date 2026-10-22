defmodule DungeonTelemetryWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :dungeon_telemetry

  plug(Plug.RequestId)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason,
    length: 1_000_000
  )

  plug(DungeonTelemetryWeb.Router)
end
