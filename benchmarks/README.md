<!-- SPDX-License-Identifier: BSD-3-Clause -->
# `go-ruby-scanf` library-level benchmark harness

Reproducible, cross-runtime benchmark of the **pure-Go `go-ruby-scanf` library**
against the reference Ruby runtimes (MRI, MRI + YJIT, JRuby, TruffleRuby). It
measures the **library primitive** through its Go API, isolated from the rbgo
interpreter, so the numbers answer: *is the pure-Go implementation as fast as the
reference runtime's own `scanf`?*

## Layout

- `go/`            — self-contained Go driver; `go.mod` pins the published library.
- `ruby/scanf.rb`  — the equivalent workload; `ruby/_harness.rb` is the shared timer.
- `run.sh`         — runs every available runtime and prints one Markdown table per
  sub-benchmark (ns/op + ratio vs MRI).

## Run

```sh
bash benchmarks/run.sh
```

Environment knobs: `OUTER` (timed passes, default 25), `WARM` (untimed warm-up
passes, default 3), and `RUBY`/`JRUBY`/`TRUFFLERUBY` to select runtime binaries.

`scanf` is a default gem that JRuby 10.1 and TruffleRuby 34 no longer bundle; run
`gem install scanf` (v1.0.0 — the version MRI ships) under each before benchmarking
them. MRI already has it.

## Method

Each process runs `WARM` untimed passes (to let the JVM/GraalVM JITs warm up),
then `OUTER` timed passes of a fixed inner loop, timed with a monotonic clock;
the **best** pass is reported as **ns/op**. Interpreter start-up is outside the
timed region. The Go driver and the Ruby script build **identical inputs** (the
same mixed `%s %d %f %x` record and the same `"1 2 … 60"` integer run) and their
outputs are checked identical to MRI before timing. Results are published, dated,
in `../docs/performance.md`.
