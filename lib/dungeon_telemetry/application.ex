defmodule DungeonTelemetry.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      %{
        id: :kafka_publisher,
        start: {
          :brod,
          :start_link_client,
          [
            [{"localhost", 19092}],
            :dungeon_kafka,
            [auto_start_producers: true]
          ]
        }
      },
      DungeonTelemetryWeb.Endpoint,
      {DungeonTelemetry.Pipeline, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DungeonTelemetry.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
