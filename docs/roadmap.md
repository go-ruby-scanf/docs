# Roadmap

`go-ruby-scanf/scanf` is grown **test-first**, each capability differential-tested against MRI
rather than built in isolation. Ruby's `scanf` — the
deterministic, interpreter-independent string scanner — is
**complete**.

| Stage | What | Status |
| --- | --- | --- |
| Integer directives | `%d` / `%u` signed decimal, `%i` with base detection, `%x` / `%X` hex and `%o` octal, widening to `*big.Int` on overflow just like Ruby's `Integer`. | **Done** |
| Float directives | `%a` / `%e` / `%f` / `%g` and uppercase forms, including hex floats (`0x1.8p1`), MRI's `123.e+3` form, and `±Infinity` saturation — matching MRI's quirky float grammar byte-for-byte. | **Done** |
| Strings, chars & sets | `%s`, `%c` (no leading-whitespace skip), and character-class sets `%[…]` / `%[^…]` with ranges, POSIX named classes, and width bounds. | **Done** |
| Widths & suppression | A decimal field width on any directive, the assignment-suppression `*` flag (`%*d`), and `%%` for a literal `%`. | **Done** |
| MRI stopping semantics | `Scan` runs the format once and `ScanAll` repeats it; both stop at the first non-match, end of input, or format exhaustion, returning the values converted so far. | **Done** |
| Differential oracle & coverage | A wide corpus scanned here and by the system `ruby` (`String#scanf`), `#inspect` compared byte-for-byte; 100% coverage, gofmt + go vet clean, green across all six 64-bit Go arches. | **Done** |

## Documented out-of-scope boundaries

These are **deliberate**, recorded so the module's surface is unambiguous:

- **No `%b` directive.** MRI's `scanf` gem has no binary directive, so to stay byte-for-byte faithful a `%b` in a format is treated as the literal characters `%b`.
- **No interpreter.** The library implements the deterministic scanning algorithm; it never runs arbitrary Ruby. The optional `IO#scanf` wiring is the consumer's job — that is why `rbgo` binds this module rather than the reverse.
- **Reference is reference Ruby (MRI).** Byte-for-byte conformance targets MRI's `String#scanf` behaviour, pinned by the differential oracle.
- **Standalone & reusable.** The module has no dependency on the Ruby runtime; the dependency runs the other way.

See [Usage & API](api.md) for the surface and [Why pure Go](why.md) for the
deterministic/interpreter split.
