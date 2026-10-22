defmodule DungeonTelemetryWeb.EventsControllerTest do
  use ExUnit.Case, async: true

  import Phoenix.ConnTest
  import Plug.Conn

  @endpoint DungeonTelemetryWeb.Endpoint

  defp post_events(body) do
    build_conn()
    |> put_req_header("content-type", "application/json")
    |> post("/events", Jason.encode!(body))
  end

  test "rejects a batch without schema_version" do
    conn = post_events(%{"events" => [%{"session_id" => "s1"}]})
    assert json_response(conn, 400) == %{"error" => "invalid_batch"}
  end

  test "rejects an unsupported schema_version" do
    conn = post_events(%{"schema_version" => 2, "events" => [%{"session_id" => "s1"}]})
    assert json_response(conn, 400) == %{"error" => "invalid_batch"}
  end

  test "rejects an empty batch" do
    conn = post_events(%{"schema_version" => 1, "events" => []})
    assert json_response(conn, 400) == %{"error" => "invalid_batch"}
  end
end
