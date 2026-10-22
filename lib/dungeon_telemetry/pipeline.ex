defmodule DungeonTelemetry.Pipeline do
  @moduledoc """
  Broadway pipeline that consumes game events from the `game.events` Kafka topic.
  """

  use Broadway

  require Logger

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module:
          {BroadwayKafka.Producer,
           hosts: [localhost: 19092],
           group_id: "dungeon-telemetry",
           topics: ["game.events"],
           offset_reset_policy: :earliest}
      ],
      processors: [
        default: [concurrency: 2]
      ]
    )
  end

  @impl true
  def handle_message(_processor, message, _context) do
    case Jason.decode(message.data) do
      {:ok, event} ->
        Logger.info("Dungeon event: #{inspect(event)}")
        message

      {:error, reason} ->
        Broadway.Message.failed(message, reason)
    end
  end
end
