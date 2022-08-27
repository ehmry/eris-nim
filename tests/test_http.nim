# SPDX-License-Identifier: MIT

import
  std / [asyncdispatch, unittest, uri]

import
  eris, eris / stores, eris_protocols / http

suite "http":
  const
    testString = "Hail ERIS!"
  var
    port = 36199
    url = "http://[::1]:" & $port
    store = newMemoryStore()
    server: StoreServer
    client: StoreClient
  block:
    server = http.newServer(store)
    asyncCheck server.serve(port = Port port)
    checkpoint("listening on " & url)
    poll()
    client = http.newStoreClient(parseUri url)
    poll()
  for i in 0 .. 7:
    test $i:
      let cap = waitFor client.encode(bs1k, testString)
      checkpoint $cap
      let serverData = waitFor store.decode(cap)
      check(cast[string](serverData) == testString)
      let clientData = waitFor client.decode(cap)
      check(cast[string](clientData) == testString)
  block:
    close client
    close server