# SPDX-License-Identifier: MIT

import
  std / [asyncdispatch, json, unittest, streams, strutils]

import
  eris, eris / tkrzw_stores

import
  vectors

suite "tkrzw":
  var store = newDbmStore("store.tkh")
  for v in testVectors():
    test v:
      case v.kind
      of "positive":
        let
          (cap, _) = waitFor store.encode(v.cap.chunkSize,
              v.data.newStringStream, v.secret)
          a = $cap
          b = v.urn
        check(a == b)
        let stream = newErisStream(store, v.cap)
        let x = cast[string](waitFor stream.readAll())
        if x.len != v.data.len:
          raise newException(ValueError, "test failed")
        check(x.toHex == v.data.toHex)
      else:
        raise newException(ValueError, "")