# SPDX-License-Identifier: MIT

import
  std / [asyncdispatch, json, sets, streams, strutils, unittest]

import
  cbor, eris, eris / cbor_stores, eris / memory_stores

import
  eris / test_vectors

suite "cbor":
  for v in testVectors():
    test v:
      var buffer: string
      block:
        var
          stream = newStringStream()
          tmp = newMemoryStore()
          store = newCborEncoder(stream)
        let (cap, _) = waitFor tmp.encode(v.cap.chunkSize,
            v.data.newStringStream, v.secret)
        waitFor store.add(cap, tmp)
        close(store)
        buffer = move stream.data
      check buffer.len > 0
      checkpoint("CBOR encoding: " & $buffer.parseCbor)
      block:
        let store = newCborDecoder(newStringStream buffer)
        check v.cap in store.caps
        let data = cast[string](waitFor newErisStream(store, v.cap).readAll())
        close(store)
        check(data.toHex == v.data.toHex)