# SPDX-License-Identifier: MIT

import
  std / [asyncdispatch, json, unittest, streams, strutils]

import
  eris, eris / composite_stores, ./jsonstores

import
  eris / test_vectors

suite "spec":
  for v in testVectors({TestKind.Positive, TestKind.Negative}):
    test v:
      if v.kind == "positive":
        let
          store = newDiscardStore()
          (cap, _) = waitFor store.encode(v.cap.chunkSize,
              v.data.newStringStream, v.secret)
          a = $cap
          b = v.urn
        check(a == b)
      block:
        let
          store = newJsonStore(v.js)
          stream = newErisStream(store, v.cap)
        let a = cast[string](waitFor stream.readAll())
        if a.len != v.data.len:
          raise newException(ValueError, "test failed")
        check(a.toHex == v.data.toHex)
suite "multi-get":
  for v in testVectors():
    test v:
      var store = newMultistore(newJsonStore(v.js))
      let data = waitFor decode(store, v.cap)
      check(cast[string](data) == v.data)
suite "multi-put":
  for v in testVectors():
    test v:
      var store = newMultistore(newDiscardStore())
      let (cap, _) = waitFor store.encode(v.cap.chunkSize,
          v.data.newStringStream, v.secret)
      check(cap == v.cap)