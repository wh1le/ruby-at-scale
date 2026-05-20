# Ruby at Scale

[![CI](https://github.com/wh1le/ruby-at-scale/actions/workflows/ci.yml/badge.svg)](https://github.com/wh1le/ruby-at-scale/actions/workflows/ci.yml)

Real-world concurrency and performance problems you'll face running Ruby in production with hands-on challenges and solutions.

## Who is this for?

Ruby developers who want to go beyond CRUD and learn how to handle high traffic, concurrency, and distributed systems, the stuff that breaks at scale.

## Problems

| Problem | Description | Difficulty |
|---------|-------------|------------|
| [Cache Stampede](lib/ruby_at_scale/cache_stampede/) | Prevent 1000 concurrent requests from hammering your DB when cache expires | Medium |
| [Rate Limiter](lib/ruby_at_scale/rate_limiter/) | Atomic sliding window rate limiting under high concurrency | Medium |

## How it works

1. Read the challenge file
2. Implement your solution
3. Run the test to verify
4. Compare with the provided solution

## Setup

```bash
bundle install
```

Update `config/database.yml` with your PostgreSQL credentials, then:

```bash
rake db:create
rake db:migrate
```

## Run

```bash
bin/server
```

## Test

```bash
# Unit/Integration specs
rspec --tag ~system

# System tests (interactive, requires running PostgreSQL and Redis)
spec/system/bin/cache_stampede_test
spec/system/bin/rate_limiter_test
```

## Dependencies

| Dependency | Purpose |
|------------|---------|
| PostgreSQL | Simulates expensive database queries |
| Redis | Cache store and distributed lock backend |
| Ruby | 4.0+ |

## ⚠️ Note

Tests delete specific Redis keys before running. They do **not** call `flushdb` - your other Redis data is safe but make sure you don't run it on critical infra.

## Blog

For a full technical deep-dive on the cache stampede problem, solutions, and tradeoffs: [Thundering Herd: The Problem That Kills Ruby Apps at Scale](https://wh1le.com/ruby-at-scale-cache-stampede)
