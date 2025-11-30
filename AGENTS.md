# Repository Guidelines

## Project Structure & Module Organization
All runtime code lives in `app.py`, a single Flask entrypoint exposing `/hello`, `/print_number`, `/crash`, and `/metrics`. Observability configuration is stored alongside the app: `prometheus.yml` defines scrape jobs, while `Dockerfile` plus `docker-compose.yml` orchestrate Flask, Prometheus, and Grafana containers. Python dependencies belong in `requirements.txt`; keep virtual environments (e.g., `.venv/`) untracked. If you add tests, place them under `tests/` mirroring the endpoint names (`tests/test_print_number.py`, etc.) so they are easy to map back to routes.

## Build, Test, and Development Commands
Run the stack locally with:
```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt        # install Flask and prometheus_client
python app.py                          # starts the API on :5000
docker compose up --build              # optional: full Flask+Prometheus+Grafana stack
curl -s localhost:5000/metrics         # confirm Prometheus exporter output
```
Use `FLASK_ENV=development` while iterating to get live reloads and detailed tracebacks.

## Coding Style & Naming Conventions
Follow PEP 8 with 4-space indentation and descriptive snake_case for functions and variables. Keep route functions concise—validate inputs up front, then emit clear responses. Metric names should remain consistent with the existing `app_*` prefix and include explicit label sets (`REQUESTS_COUNT.labels(method=..., endpoint=...)`). Docstrings or inline comments are only needed to describe non-obvious logic.

## Testing Guidelines
There is no automated suite yet, so prioritize fast unit tests using `pytest` once introduced. Name tests after the route or behavior under test (`test_print_number_requires_param`). Mock HTTP requests with Flask’s test client and validate both payload and Prometheus counters. Until pytest coverage exists, perform smoke checks with `curl` or `httpie` calls against `/hello`, `/print_number?number=1.5`, and `/metrics`, and document any edge cases you verify manually in the pull request.

## Commit & Pull Request Guidelines
Write focused commits in the imperative mood (`Add Grafana dashboard config`) and group unrelated work separately to simplify reviews. Every pull request should describe the change, reference an issue if applicable, list reproducible test commands, and include screenshots for Grafana or Prometheus updates. Flag migrations or breaking API shifts in both the PR title and body so downstream dashboards can be updated before merging. Keep PRs small enough to review within 15 minutes; larger changes should be broken into preparatory patches.

## Observability & Configuration Tips
When extending metrics, update `prometheus.yml` scrape targets if new endpoints or ports are involved, and share suggested Grafana dashboard JSON or import steps in the PR. Expose only authenticated endpoints publicly; keep `/metrics` behind internal networks or basic auth when deploying beyond local development.***
