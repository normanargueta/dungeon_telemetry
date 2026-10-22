defmodule DungeonTelemetry.EventPublisher do
  @topic "game.events"

  def publish(event) do
    key = Map.fetch!(event, "session_id")
    payload = Jason.encode!(event)

    :brod.produce_sync(
      :dungeon_kafka,
      @topic,
      :hash,
      key,
      payload
    )
  end
end
