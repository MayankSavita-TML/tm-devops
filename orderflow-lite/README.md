# OrderFlow-Lite

A small Express + MySQL order processing API with an internal background
worker, built as the running case study for a DevOps training course
(CI/CD, Docker, Kubernetes, Terraform, Ansible, DevSecOps).

It is a single Node.js process: the HTTP API and the order-processing
worker both run in-process (the worker is a `setInterval` loop started
alongside the server, not a separate service) — see
[`src/worker/processOrders.js`](src/worker/processOrders.js).

## How it works

1. `POST /orders` creates an order with `status = pending` and writes a
   `created` row to `order_events`.
2. The background worker polls for `pending` orders every
   `WORKER_POLL_INTERVAL_MS` (default 5000ms), in small batches.
3. For each order it picks up, it writes a `processing_started` event,
   simulates ~1–2s of work, then randomly succeeds (90%) or fails (10%),
   updating the order's `status` and writing a final `completed`/`failed`
   event.
4. `GET /orders/:id` returns the order plus its full `order_events`
   history, so you can see this whole lifecycle.

**Note**: each running replica starts its own independent worker loop —
there's no coordination between replicas. See
[`k8s/README.md`](k8s/README.md) for why this matters once you scale past
one replica (flagged there as an architecture-review discussion point,
not something fixed in this codebase).

## Running locally

Requires Node.js 20+ and a MySQL 8 instance.

```bash
npm install
cp .env.example .env   # fill in real values — see below
npm run dev             # nodemon, restarts on change
# or
npm start                # plain node
```

Apply the schema once against a fresh database:

```bash
mysql -h <DB_HOST> -u <DB_USER> -p <DB_NAME> < sql/init.sql
```

### Environment variables

All configuration is read from environment variables — nothing is
hardcoded. See [`.env.example`](.env.example) for the full list with
placeholder values:

| Variable | Purpose | Default |
|---|---|---|
| `PORT` | HTTP port the server listens on | `3000` |
| `DB_HOST` | MySQL host | — required |
| `DB_PORT` | MySQL port | — required |
| `DB_USER` | MySQL user | — required |
| `DB_PASSWORD` | MySQL password | — required |
| `DB_NAME` | MySQL database name | — required |
| `API_KEY` | Required value of the `x-api-key` header on all `/orders*` routes | — required |
| `WORKER_POLL_INTERVAL_MS` | How often the background worker polls for pending orders | `5000` |

### Running with Docker

```bash
docker build -t orderflow-lite:local .
docker run -p 3000:3000 \
  -e DB_HOST=host.docker.internal -e DB_PORT=3306 \
  -e DB_USER=orderflow -e DB_PASSWORD=changeme -e DB_NAME=orderflow \
  -e API_KEY=changeme-api-key \
  orderflow-lite:local
```

The image runs as a non-root user and exposes a `HEALTHCHECK` against
`/health`. See the [`Dockerfile`](Dockerfile).

### Running on Kubernetes (kind / Minikube)

See [`k8s/README.md`](k8s/README.md) for manifests, apply order, and how
to reach the service on kind vs. Minikube.

### Tests

```bash
npm test        # jest
npm run test:ci # jest with the junit reporter (outputs junit.xml)
```

## Accessing the API

Every request to `/orders` and its subroutes must include the API key:

```
x-api-key: <API_KEY>
```

Missing or incorrect keys get a `401`. `/health` and `/ready` do not
require a key.

```bash
curl -H "x-api-key: changeme-api-key" http://localhost:3000/orders
```

## API Reference

### `GET /health`

Liveness probe. Always returns `200` — does not touch the database.

**Response `200`**
```json
{ "status": "ok" }
```

### `GET /ready`

Readiness probe. Runs a trivial query against MySQL.

**Response `200`** (DB reachable)
```json
{ "status": "ready" }
```

**Response `503`** (DB unreachable)
```json
{ "status": "not ready" }
```

### `POST /orders`

Create a new order. Requires `x-api-key`.

**Request body**
```json
{
  "customer_name": "Ada Lovelace",
  "item": "Widget",
  "quantity": 2
}
```

| Field | Type | Required | Notes |
|---|---|---|---|
| `customer_name` | string | yes | |
| `item` | string | yes | |
| `quantity` | integer | yes | must be a positive integer |

**Response `201`** — the created order (`status` starts as `"pending"`)
```json
{
  "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "customer_name": "Ada Lovelace",
  "item": "Widget",
  "quantity": 2,
  "status": "pending",
  "created_at": "2026-07-13T10:00:00.000Z",
  "updated_at": "2026-07-13T10:00:00.000Z"
}
```

**Response `400`** — missing/invalid fields
```json
{ "error": "customer_name, item, and quantity are required" }
```
```json
{ "error": "quantity must be a positive integer" }
```

**Response `401`** — missing/incorrect `x-api-key`
```json
{ "error": "unauthorized: missing or invalid x-api-key header" }
```

### `GET /orders`

List all orders, newest first. Requires `x-api-key`.

**Response `200`**
```json
[
  {
    "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    "customer_name": "Ada Lovelace",
    "item": "Widget",
    "quantity": 2,
    "status": "completed",
    "created_at": "2026-07-13T10:00:00.000Z",
    "updated_at": "2026-07-13T10:00:05.000Z"
  }
]
```

### `GET /orders/:id`

Get a single order plus its full `order_events` history. Requires
`x-api-key`.

**Response `200`**
```json
{
  "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "customer_name": "Ada Lovelace",
  "item": "Widget",
  "quantity": 2,
  "status": "completed",
  "created_at": "2026-07-13T10:00:00.000Z",
  "updated_at": "2026-07-13T10:00:05.000Z",
  "events": [
    { "id": "...", "order_id": "3fa85f64-...", "event_type": "created", "detail": "Order created for Ada Lovelace", "created_at": "2026-07-13T10:00:00.000Z" },
    { "id": "...", "order_id": "3fa85f64-...", "event_type": "processing_started", "detail": "Worker picked up order for processing", "created_at": "2026-07-13T10:00:03.000Z" },
    { "id": "...", "order_id": "3fa85f64-...", "event_type": "completed", "detail": "Order processed successfully", "created_at": "2026-07-13T10:00:05.000Z" }
  ]
}
```

**Response `404`** — no order with that id
```json
{ "error": "order not found" }
```

## Project layout

```
src/
  app.js                  Express app (routes + middleware), no listen()
  index.js                Entry point: starts the server + worker
  db.js                   Shared mysql2 connection pool
  middleware/auth.js      x-api-key check
  routes/orders.js        /orders route handlers
  worker/processOrders.js Background order-processing loop
sql/init.sql              Schema (orders, order_events)
tests/                    Jest + Supertest test suite
k8s/                      Kubernetes manifests (see k8s/README.md)
Dockerfile                Multi-stage build, non-root runtime user
```

## Training material

This repo also backs several DevOps training labs and intentionally
contains seeded findings/failures for those exercises — see
[`TRAINING_SEEDS.md`](TRAINING_SEEDS.md) (Trivy/GitLeaks) and
`CAPSTONE_FAILURE_GUIDE.md` (trainer-only, if present on your branch) for
what's seeded, where, and why.
