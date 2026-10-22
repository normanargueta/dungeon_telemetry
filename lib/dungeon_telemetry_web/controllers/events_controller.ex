defmodule DungeonTelemetryWeb.EventsController do
  use Phoenix.Controller, formats: [:json]

  def create(conn, %{
        "schema_version" => 1,
        "events" => events
      })
      when is_list(events) and events != [] do
    result =
      events
      |> Enum.reduce_while(:ok, fn event, _acc ->
        try do
          case DungeonTelemetry.EventPublisher.publish(event) do
            :ok -> {:cont, :ok}
            {:error, reason} -> {:halt, {:error, reason}}
          end
        rescue
          error -> {:halt, {:error, Exception.message(error)}}
        end
      end)

    case result do
      :ok ->
        json(conn, %{status: "accepted"})

      {:error, reason} ->
        conn
        |> put_status(:service_unavailable)
        |> json(%{error: "publish_failed", detail: inspect(reason)})
    end
  end

  def create(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "invalid_batch"})
  end
end
