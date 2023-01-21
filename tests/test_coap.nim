# SPDX-License-Identifier: MIT

import
  std / [asyncdispatch, json, streams, unittest]

from std / net import parseIpAddress

import
  eris, eris / [memory_stores, coap_stores]

import
  ./vectors

const
  url = "coap+tcp://[::1]:5685"
var
  store = newMemoryStore()
  server = newServer(store)
server.serve(parseIpAddress"::1", Port 5685)
var client = waitFor newStoreClient(url)
suite "get":
  setup:
    clear(store)
  for v in testVectors():
    test v:
      let cap = waitFor store.encode(v.cap.chunkSize, v.data.newStringStream,
                                     v.secret)
      let data = waitFor client.decode(cap)
      check(cast[string](data) == v.data)
suite "put":
  setup:
    clear(store)
  for v in testVectors():
    test v:
      let cap = waitFor client.encode(v.cap.chunkSize, v.data.newStringStream,
                                      v.secret)
      let data = waitFor store.decode(cap)
      check(cast[string](data) == v.data)
poll()
close client
close server