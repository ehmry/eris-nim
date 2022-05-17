# SPDX-License-Identifier: MIT

import
  std / [asyncdispatch, unittest]

import
  eris, eris / stores, eris_protocols / coap

import
  coap / common

suite "server_client":
  var url: Uri
  check url.fromString "coap+tcp://[::1]:5683"
  var
    store = newMemoryStore()
    server = newServer(store)
  server.serve()
  poll()
  var client = waitFor newStoreClient(url)
  const
    testData = "Hail ERIS!"
  test testData:
    let
      cap = waitFor client.encode(bs1k, testData)
      serverData = waitFor store.decode(cap)
    check(cast[string](serverData) == testData)
    let clientData = waitFor client.decode(cap)
    check(cast[string](clientData) == testData)
  close client
  close server