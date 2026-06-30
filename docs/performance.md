# Performance

`go-ruby-scanf/scanf` is the pure-Go library that
[`rbgo`](https://github.com/go-embedded-ruby/ruby) binds for Ruby's `scanf`. This
page records the **methodology** for a comparative benchmark of that module
against the reference Ruby runtimes, part of the ecosystem-wide per-module
parity suite.

## What is measured

The **same** Ruby script — a `String#scanf` parse of a representative formatted-data string — is run under every runtime. `rbgo`'s
number reflects **this pure-Go library doing the work**; every other column is
that interpreter's own stdlib. So the comparison is the **Ruby-visible
operation**, apples-to-apples across interpreters. The script prints a
deterministic checksum and its output is checked **byte-identical to MRI** before
timing.

- **Method:** best-of-5 wall time (best, not mean, to suppress scheduler noise);
  single-shot processes, no warm-up beyond the script's own loop.
- **Runtimes:** `ruby` (MRI, the oracle) and `ruby --yjit`; `jruby` (OpenJDK);
  `truffleruby` (GraalVM CE Native).
- The benchmark script and harness live in rbgo's repo under
  [`bench/modules/`](https://github.com/go-embedded-ruby/ruby/tree/main/bench/modules)
  (`scanf.rb` + `run.sh`). Reproduce:
  `RBGO=./rbgo TRUFFLE=truffleruby bash bench/modules/run.sh 5`.

## Result

## Result (best of 5, ms)

| Runtime | time | vs MRI |
| --- | ---: | ---: |
| **rbgo** (go-ruby-scanf) | 150 | 0.26× |
| MRI (ruby 4.0.5) | 570 | 1.00× |
| MRI + YJIT | 550 | 0.96× |
| JRuby 10.1.0.0 | n/a* | — |
| TruffleRuby 34.0.1 | n/a* | — |

\* *`scanf` is not bundled in JRuby 10.1 or TruffleRuby 34 (both `LoadError` on `require` — it was removed as a default gem in those distributions), so no JRuby/TruffleRuby number could be measured. The row runs on MRI, MRI+YJIT and rbgo.*

rbgo runs on **go-ruby-scanf** and is **~4x faster than MRI** here (0.26x): MRI's scanf format engine is Ruby-coded. `scanf` is **not bundled** in JRuby 10.1 or TruffleRuby 34 (both `LoadError` on `require` — it was removed as a default gem), so those two columns have no number.

!!! note "Honest framing"
    JRuby and TruffleRuby are timed **cold, single-shot**, so they carry JVM /
    Graal startup on every run — read them as one-shot `ruby file.rb` costs, the
    same way `rbgo` and MRI are measured, not as steady-state JIT numbers. Rows
    that complete in well under ~200 ms carry the most relative noise; treat
    their ratios as order-of-magnitude. These are **real measured numbers** from
    the 2026-06-30 run (Apple M-series; `ruby 4.0.5 +PRISM`, `jruby 10.1.0.0`,
    `truffleruby 34.0.1`) — nothing is fabricated or cherry-picked.
