# SPDX-License-Identifier: MIT

import
  std / [asyncdispatch, asyncfutures, net, parseopt, uri]

import
  preserves, syndicate, syndicate / actors

import
  ./erisresolver_config

import
  ../../eris, ../coap_stores, ../composite_stores, ../http_stores,
  ../syndicate_stores, ../tkrzw_stores, ../url_stores, ./common

proc main*(opt: var OptParser): string =
  if opt.kind != cmdEnd:
    return ("invalid parameter " & opt.key)
  bootDataspace("main")do (ds: Ref; turn: var Turn):
    var resolver = MultiStore()
    stderr.writeLine "Connecting to Syndicate peer over stdio…"
    connectStdio(ds, turn)
    stderr.writeLine "Connected."
    during(turn, ds, ?TkrzwDatabase)do (path: string; ops: Operations):
      stderr.writeLine("opening store at ", path, ". This could take a while…")
      var dbStore = newDbmStore(path, ops)
      resolver.add(dbStore, ops)
      stderr.writeLine("opened store at ", dbStore)
    do:
      close(resolver, dbStore)
      stderr.writeLine("closed store at ", dbStore)
    during(turn, ds, ?Peer)do (s: string; ops: Operations):
      let uri = parseUri(s)
      var store: ErisStore
      url_stores.newStoreClient(uri).addCallback(turn)do (turn: var Turn;
          fut: Future[ErisStore]):
        store = fut.read
        resolver.add(store, ops)
        stderr.writeLine("opened store at ", uri)
    do:
      close(resolver, store)
      stderr.writeLine("closed store at ", uri)
    during(turn, ds, ?CoapServer)do (ip: string; port: Port; ops: Operations):
      var server = coap_stores.newServer(resolver, ops)
      server.serve(ip.parseIpAddress, port)
      stderr.writeLine("serving CoAP sessions on ", ip, ":", port)
    do:
      close(server)
      stderr.writeLine("stopped listening for CoAP sessions on ", ip)
    during(turn, ds, ?HttpServer)do (ip: string; port: Port; ops: Operations):
      var server = http_stores.newServer(resolver)
      asyncCheck(turn, server.serve(ops, ip.parseIpAddress, port))
      stderr.writeLine("serving HTTP sessions on ", ip)
    do:
      close(server)
      stderr.writeLine("stopped listening for HTTP sessions on ", ip)
    during(turn, ds, ?SyndicateRelay[Ref])do (ds: Ref; ops: Operations):
      stderr.writeLine "Starting relay to ", ds, '.'
      let storeFacet = newStoreFacet(turn, resolver, ds, ops)
    do:
      stop(turn, storeFacet)
      stderr.writeLine "Stopped relay to ", ds, '.'
  runForever()

when isMainModule:
  var opts = initOptParser()
  exits main(opts)