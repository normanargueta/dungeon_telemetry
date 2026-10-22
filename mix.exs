defmodule DungeonTelemetry.MixProject do
  use Mix.Project

  def project do
    [
      app: :dungeon_telemetry,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {DungeonTelemetry.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:broadway, "~> 1.3"},
      {:broadway_kafka, "~> 0.7.0"},
      {:jason, "~> 1.4"},
      {:snappyer, "~> 1.2"},
      {:phoenix, "~> 1.8"},
      {:bandit, "~> 1.8"}
    ]
  end
end
