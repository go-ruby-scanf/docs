# Usage & API

The public API lives at the module root (`github.com/go-ruby-scanf/scanf`). It is **Ruby-shaped but Go-idiomatic**: `Scan` / `ScanAll` mirror `String#scanf` without and with a block, while the surface follows Go conventions — an explicit `error`, value types, no global state.

!!! success "Status: implemented"
    The library is built and importable as `github.com/go-ruby-scanf/scanf`, bound into
    `rbgo` as a native module; see [Roadmap](roadmap.md).

## Install

```sh
go get github.com/go-ruby-scanf/scanf
```

## Worked example

```go
// Scan runs the format once — MRI's String#scanf without a block.
vs, _ := scanf.Scan("abc 123", "%s %d")
fmt.Println(vs) // [abc 123]   ("abc" string, 123 int)

vs, _ = scanf.Scan("50%", "%d%%")
fmt.Println(vs) // [50]

vs, _ = scanf.Scan("42 abc", "%d %d")
fmt.Println(vs) // [42]        (partial: the second %d found no integer)

// ScanAll repeats the format until the input is exhausted — MRI's block form.
all, _ := scanf.ScanAll("1 2 3 4", "%d %d")
fmt.Println(all) // [[1 2] [3 4]]
```

## Shape

```go
// Scan parses values out of input per format, once (String#scanf without a
// block). A directive that fails ends the scan; the result holds the values
// converted so far. The error is always nil (a non-match is a shorter slice,
// not a failure) — it is present for an idiomatic Go shape.
func Scan(input, format string) ([]any, error)

// ScanAll repeatedly applies format to input (String#scanf with a block /
// block_scanf), returning one group per successful pass until the input is
// exhausted or a pass converts nothing.
func ScanAll(input, format string) ([][]any, error)
```

## Value model

Each converted value is one of a small, fixed set of Go types, so a host can map
its own objects to and from this package:

| Ruby      | Go                                            |
| --------- | --------------------------------------------- |
| `Integer` | `int`, or `*big.Int` when it overflows `int`  |
| `Float`   | `float64`                                     |
| `String`  | `string`                                      |

A suppressed directive (`%*…`) and `%%` contribute no value; a directive that
fails to match ends the scan, so the result holds only what was converted before
that point.

## MRI conformance

Correctness is defined by reference Ruby. A **differential oracle** runs a wide
corpus — every directive, width, set, suppression flag, literal, and
partial/failed match, in both the single and block forms — through both the
system `ruby` (`String#scanf`) and this library and compares the two `#inspect`
renderings **byte-for-byte**. The oracle skips itself where `ruby` is not on
`PATH` (e.g. the qemu arch lanes), so the cross-arch builds still validate the
library.

## Relationship to Ruby

`go-ruby-scanf/scanf` is **standalone and reusable**, and is the backend bound into
[go-embedded-ruby](https://github.com/go-embedded-ruby/ruby) by `rbgo` as a
native module — the same way [go-ruby-regexp](https://github.com/go-ruby-regexp)
and [go-ruby-erb](https://github.com/go-ruby-erb) are bound. The dependency runs
the other way: this library has no dependency on the Ruby runtime.
