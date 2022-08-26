# SPDX-License-Identifier: MIT

import
  std / [asyncdispatch, random, unittest, uri]

import
  eris, eris / stores, eris_protocols / http

suite "http":
  var
    store = newMemoryStore()
    server = http.newServer(store)
    port = rand(0x0000FFFF) or 1024
    url = parseUri("http://[::1]:" & $port)
  asyncCheck server.serve(port = Port port)
  poll()
  var client = http.newStoreClient(url)
  var
    testString = "Hail ERIS!"
    testData = cast[seq[byte]](testString)
  test testString:
    let cap = waitFor client.encode(bs1k, testString)
    echo "got ", cap, " for encoding"
    discard waitFor store.encode(bs1k, testString)
    let serverData = waitFor store.decode(cap)
    echo "got serverData"
    check(serverData == testData)
    let clientData = waitFor client.decode(cap)
    check(clientData == testData)
  close client
  close server