# SPDX-License-Identifier: MIT

import
  std / [asyncdispatch, json, streams, unittest, uri]

import
  eris, eris / [memory_stores, http_stores]

import
  eris / test_vectors

const
  port = 36199
  url = "http://[::1]:" & $port
var
  store = newMemoryStore()
  server = newServer(store)
asyncCheck server.serve(port = Port port)
var client = waitFor http_stores.newStoreClient(parseUri url)
suite "get":
  setup:
    clear(store)
  for v in testVectors():
    test v:
      let (cap, _) = waitFor store.encode(v.cap.chunkSize,
          v.data.newStringStream, v.secret)
      let data = waitFor client.decode(cap)
      check(cast[string](data) == v.data)
suite "put":
  setup:
    clear(store)
  for v in testVectors():
    test v:
      let (cap, _) = waitFor client.encode(v.cap.chunkSize,
          v.data.newStringStream, v.secret)
      let data = waitFor store.decode(cap)
      check(cast[string](data) == v.data)
poll()
close client
close server