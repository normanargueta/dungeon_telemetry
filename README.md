# DungeonTelemetry

A small Elixir service for ingesting game telemetry. Clients send batches of
events over HTTP. Each event is published to Kafka, keyed by `session_id` so a
session's events stay ordered within one partition. A Broadway pipeline then
consumes them.

```
 game client ──POST /events──▶ Phoenix (Bandit) ──brod──▶ Kafka topic "game.events"
                                                                │
                                                                ▼
                                                 Broadway pipeline (BroadwayKafka)
```

## Stack

- [Phoenix](https://www.phoenixframework.org/) on [Bandit](https://github.com/mtrudel/bandit): HTTP ingestion endpoint
- [brod](https://github.com/kafka4beam/brod): Kafka producer
- [Broadway](https://github.com/dashbitco/broadway) + [BroadwayKafka](https://github.com/dashbitco/broadway_kafka): consumer pipeline
- [Redpanda](https://redpanda.com/): Kafka-compatible broker for local development

## Running locally

Requirements: Elixir 1.18+, Docker.

```sh
# 1. Start the broker (Kafka API exposed on localhost:19092)
docker compose up -d

# 2. Create the topic
docker exec dungeon-redpanda rpk topic create game.events -p 3

# 3. Fetch deps and start the app (HTTP on http://localhost:4000)
mix deps.get
mix run --no-halt
```

## Sending events

```sh
curl -X POST http://localhost:4000/events \
  -H 'content-type: application/json' \
  -d '{
        "schema_version": 1,
        "events": [
          {"session_id": "abc-123", "type": "room_entered", "room": "crypt_3"},
          {"session_id": "abc-123", "type": "monster_slain", "monster": "skeleton"}
        ]
      }'
```

| Response | Meaning |
| --- | --- |
| `200 {"status":"accepted"}` | All events were published |
| `400 {"error":"invalid_batch"}` | Missing or unsupported `schema_version`, or `events` is empty or not a list |
| `503 {"error":"publish_failed", ...}` | Kafka rejected the publish, or an event has no `session_id` |

Every event must include a `session_id`, which is used as the partition key.
Consumed events are logged by `DungeonTelemetry.Pipeline`.

## Tests

```sh
mix test
```

## Roadmap

This is an early-stage project. Planned work, roughly in order:

### Phase 1: Reliable ingestion

- [ ] Event IDs and idempotent publishing, so retried batches don't create duplicates
- [ ] Versioned event schema validation with per-event errors
- [ ] Publish each batch in one Kafka call instead of one call per event
- [ ] Dead-letter topic (`game.events.dlq`) for events that fail to decode or process
- [ ] Runtime configuration from env (Kafka hosts, topic, port)

### Phase 2: Make the data useful

- [ ] Session aggregation with Broadway batchers (rooms cleared, deaths, time per floor, loot)
- [ ] Persist raw events and aggregates (ClickHouse or Postgres)
- [ ] Live dashboard with Phoenix LiveView: active sessions, deaths per room, hardest monsters
- [ ] Load generator that simulates players running dungeons

### Phase 3: Run it like a real service

- [ ] `:telemetry` metrics (ingest rate, publish latency, consumer lag) with a Prometheus endpoint
- [ ] Rate limiting per client, maximum batch size, `429` responses
- [ ] CI with GitHub Actions, including an integration test against Redpanda
- [ ] Dockerfile and a one-command `docker compose up` for the full stack

Feedback and ideas are welcome. Feel free to open an issue.

## License

[MIT](LICENSE)
