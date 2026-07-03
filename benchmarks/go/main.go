// SPDX-License-Identifier: BSD-3-Clause
package main

import (
	"strconv"
	"strings"

	"github.com/go-ruby-scanf/scanf"
)

func main() {
	// A single mixed record exercising the four common directives at once:
	// %s (string), %d (decimal int), %f (float), %x (hex int) — the inverse of a
	// sprintf("%s %d %f %x", ...). Identical bytes to the Ruby workload.
	const mixed = "lorem 42 3.14159 deadbeef"

	// A long whitespace-separated run of integers for the multi-match path:
	// "1 2 3 ... 60", matched two-at-a-time so ScanAll / block_scanf iterate 30
	// times per call. This is scanf's streaming mode, the inverse of a loop of
	// sprintf.
	pairs := buildPairs(60)

	bench("scan-mixed", 1000, func() { v, _ := scanf.Scan(mixed, "%s %d %f %x"); sink = v })
	bench("scanall-pairs", 500, func() { v, _ := scanf.ScanAll(pairs, "%d %d"); sink = v })
}

// buildPairs returns "1 2 3 ... n" — the same string the Ruby side builds with
// (1..n).to_a.join(" ").
func buildPairs(n int) string {
	var b strings.Builder
	for i := 1; i <= n; i++ {
		if i > 1 {
			b.WriteByte(' ')
		}
		b.WriteString(strconv.Itoa(i))
	}
	return b.String()
}
