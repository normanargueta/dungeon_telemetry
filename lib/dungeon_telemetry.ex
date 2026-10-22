defmodule DungeonTelemetry do
  @moduledoc """
  Game telemetry ingestion: events are accepted over HTTP, published to Kafka,
  and consumed by a Broadway pipeline.

  See `DungeonTelemetryWeb.EventsController`, `DungeonTelemetry.EventPublisher`
  and `DungeonTelemetry.Pipeline`.
  """
end
