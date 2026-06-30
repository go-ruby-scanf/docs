# go-ruby-scanf documentation

**Ruby's scanf — the inverse of sprintf — in pure Go, MRI-compatible, no cgo.**

`go-ruby-scanf/scanf` is a faithful, pure-Go (zero cgo) reimplementation of Ruby's scanf string scanner,
matching reference Ruby (MRI) byte-for-byte. The module path is
`github.com/go-ruby-scanf/scanf`.

It is a **standalone, reusable library**: the module is importable by any Go
program, and it is the backend bound into
[go-embedded-ruby](https://github.com/go-embedded-ruby/ruby) by `rbgo` as a
native module — just like [go-ruby-regexp](https://github.com/go-ruby-regexp)
and [go-ruby-erb](https://github.com/go-ruby-erb). The dependency runs the other
way: this library has **no dependency on the Ruby runtime**.

!!! success "Status: complete — MRI byte-exact"
    A faithful port of MRI's `scanf` gem: the **`Scan`** and **`ScanAll`** entry points covering **integer** (`%d`/`%i`/`%x`/`%o`, `*big.Int` on overflow), **float** (`%a`/`%e`/`%f`/`%g`, hex floats, MRI's quirky forms), **`%s`** / **`%c`**, **character-class sets** `%[…]`, **field widths**, **assignment suppression** (`%*`), and MRI's exact **stopping semantics**. Validated by a **differential oracle** against the system `ruby` / `String#scanf` at 100% coverage, `gofmt` + `go vet` clean, CI green across the six 64-bit Go targets.

## Quick taste

```go
vs, _ := scanf.Scan("abc 123", "%s %d")
// [abc 123]   ("abc" string, 123 int)

vs, _ = scanf.Scan("42 abc", "%d %d")
// [42]        (partial: the second %d found no integer)

all, _ := scanf.ScanAll("1 2 3 4", "%d %d")
// [[1 2] [3 4]]
```

## Repositories

| Repo | What it is |
| --- | --- |
| [`scanf`](https://github.com/go-ruby-scanf/scanf) | the library — Ruby's scanf string scanner in pure Go |
| [`docs`](https://github.com/go-ruby-scanf/docs) | this documentation site (MkDocs Material, versioned with mike) |
| [`go-ruby-scanf.github.io`](https://github.com/go-ruby-scanf/go-ruby-scanf.github.io) | the organization landing page (Hugo) |
| [`brand`](https://github.com/go-ruby-scanf/brand) | logo and brand assets |


## Principles

- **Pure Go, `CGO_ENABLED=0`** — trivial cross-compilation, a single static
  binary, no C toolchain.
- **MRI byte-exact.** Output matches reference Ruby exactly, not approximately,
  validated by a differential oracle against the `ruby` binary.
- **Standalone & reusable.** No dependency on the Ruby runtime — the dependency
  runs the other way.
- **100% test coverage** is the target, enforced as a CI gate.

## Where to go next

- [Why pure Go](why.md) — why this slice of Ruby is deterministic enough to live
  as a standalone, interpreter-independent Go library.
- [Usage & API](api.md) — the public surface and worked examples.
- [Roadmap](roadmap.md) — what is done and what is downstream by design.

Source lives at [github.com/go-ruby-scanf/scanf](https://github.com/go-ruby-scanf/scanf).
