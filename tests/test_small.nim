# SPDX-License-Identifier: MIT

import
  std / [asyncdispatch, json, unittest, strutils]

import
  eris, ./jsonstores

import
  vectors

suite "encode":
  for v in testVectors():
    test v:
      let
        store = newDiscardStore()
        a = $(waitFor store.encode(v.cap.blockSize, v.data, v.secret))
        b = v.urn
      check(a == b)
suite "decode":
  for v in testVectors():
    test v:
      let
        store = newJsonStore(v.js)
        stream = newErisStream(store, v.cap)
        streamLength = waitFor stream.length()
      check((streamLength - v.data.len.BiggestUInt) <
          v.cap.blockSize.BiggestUInt)
      let a = cast[string](waitFor stream.readAll())
      check(a.len == v.data.len)
      check(a.toHex == v.data.toHex)
      assert(a == v.data, "decode mismatch")