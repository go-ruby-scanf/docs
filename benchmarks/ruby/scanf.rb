# frozen_string_literal: true
# SPDX-License-Identifier: BSD-3-Clause
#
# scanf is a default gem that was dropped from JRuby 10.1 and TruffleRuby 34's
# bundled set; `gem install scanf` (v1.0.0, the same version MRI bundles) restores
# it there. On MRI it is already present.
require "scanf"
require_relative "_harness"

# A single mixed record exercising the four common directives at once:
# %s / %d / %f / %x — the inverse of sprintf("%s %d %f %x", ...). Identical bytes
# to the Go driver.
MIXED = "lorem 42 3.14159 deadbeef"

# "1 2 3 ... 60" — a long integer run for the multi-match path, matched
# two-at-a-time so block_scanf iterates 30 times per call. Same string the Go side
# builds.
PAIRS = (1..60).to_a.join(" ")

# Output guard: fail loudly if this runtime's scanf disagrees with the MRI oracle
# (checked identical before any timing is recorded).
raise "mixed mismatch" unless MIXED.scanf("%s %d %f %x") == ["lorem", 42, 3.14159, 3735928559]
all = PAIRS.block_scanf("%d %d") { |a, b| [a, b] }
raise "scanall mismatch" unless all.length == 30 && all.first == [1, 2] && all.last == [59, 60]

bench("scan-mixed", 1000) { MIXED.scanf("%s %d %f %x") }
bench("scanall-pairs", 500) { PAIRS.block_scanf("%d %d") { |a, b| [a, b] } }
