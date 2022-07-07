# SPDX-License-Identifier: MIT

import
  std / [asyncdispatch, json, unittest, streams, strutils]

import
  eris, ./jsonstores

import
  vectors

suite "spec":
  for v in testVectors():
    test v:
      block:
        let
          store = newDiscardStore()
          a = $(waitFor store.encode(v.cap.blockSize, v.data.newStringStream,
                                     v.secret))
          b = v.urn
        if v.kind == "encode-decode-success":
          check(a == b)
      block:
        let
          store = newJsonStore(v.js)
          stream = newErisStream(store, v.cap)
        let a = cast[string](waitFor stream.readAll())
        check(a.len == v.data.len)
        check(a.toHex == v.data.toHex)