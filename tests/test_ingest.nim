# SPDX-License-Identifier: MIT

## Test that the current cap of `ErisIngest` can be queried
## without affecting further appends.
import
  std / [asyncdispatch, unittest, strutils]

import
  eris, eris / stores

test "ingest":
  var
    store = newMemoryStore()
    ingestA = newErisIngest(store, bs1k)
    ingestB = newErisIngest(store, bs1k)
    buf = newSeq[byte](1337)
    a, b: ErisCap
  for i in 0 .. 23:
    for b in buf.mitems:
      b = uint8 i
    waitFor ingestA.append(buf)
    a = waitFor ingestA.cap
    waitFor ingestB.append(buf)
  b = waitFor ingestB.cap
  check(a == b)
  discard waitFor decode(store, a)