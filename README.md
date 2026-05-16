# Ruby at Scale

Real-world concurrency and performance problems you'll face running Ruby in production with hands-on challenges and solutions.

## Who is this for?

Ruby developers who want to go beyond CRUD and learn how to handle high traffic, concurrency, and distributed systems, the stuff that breaks at scale.

## Problems

| Problem | Description | Difficulty |
|---------|-------------|------------|
| [Cache Stampede](lib/ruby_at_scale/cache_stampede/) | Prevent 1000 concurrent requests from hammering your DB when cache expires | Medium |

## How it works

1. Read the challenge file
2. Implement your solution
3. Run the test to verify
4. Compare with the provided solution

## Setup

```bash
bundle install
bin/setup
```

## Run

```bash
bin/server
```

## Test

```bash
# Cache Stampede
test/ruby_at_scale/cache_stampede_test
```

## Dependencies

| Dependency | Purpose |
|------------|---------|
| PostgreSQL | Simulates expensive database queries |
| Redis | Cache store and distributed lock backend |
| Ruby | 3.0+ recommended |

## ⚠️ Note

Tests delete specific Redis keys before running. They do **not** call `flushdb` - your other Redis data is safe but make sure you don't run it on critical infra.

## Blog

For a full technical deep-dive on the cache stampede problem, solutions, and tradeoffs: [Thundering Herd: The Problem That Kills Ruby Apps at Scale](https://wh1le.com/ruby-at-scale-cache-stampede)
