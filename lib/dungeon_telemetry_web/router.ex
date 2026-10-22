defmodule DungeonTelemetryWeb.Router do
  use Phoenix.Router

  post("/events", DungeonTelemetryWeb.EventsController, :create)
end
