# SPDX-License-Identifier: MIT

import
  std / [asyncdispatch, json, streams, os, unittest]

import
  syndicate, syndicate / capabilities

import
  eris, eris / [memory_stores, syndicate_stores]

import
  ./vectors

const
  testString = "Hail ERIS!"
proc unixSocketPath(): Unix =
  result.path = getEnv("SYNDICATE_SOCK")
  if result.path == "":
    result.path = getEnv("XDG_RUNTIME_DIR", "/run/user/1000") / "dataspace"

proc runTest(backend, frontend: ErisStore): Future[void] {.async.} =
  suite "get":
    for v in testVectors():
      test v:
        let (cap, _) = await backend.encode(v.cap.chunkSize,
            v.data.newStringStream, v.secret)
        check(cap == v.cap)
        let data = await frontend.decode(cap)
        check(cast[string](data) == v.data)
  suite "put":
    for v in testVectors():
      test v:
        let (cap, _) = await frontend.encode(v.cap.chunkSize,
            v.data.newStringStream, v.secret)
        check(cap == v.cap)
        let data = await backend.decode(cap)
        check(cast[string](data) == v.data)

proc bootTest(ds: Ref; turn: var Turn) =
  connect(turn, unixSocketPath(), capabilities.mint().toPreserve(Ref))do (
      turn: var Turn; ds: Ref):
    var
      backend = newMemoryStore()
      storeFacet {.used.} = newStoreFacet(turn, backend, ds)
      frontend = newSyndicateStore(turn, ds, {Get, Put})
    asyncCheck runTest(backend, frontend)

suite "syndicate":
  if fileExists(unixSocketPath().path):
    bootDataspace("test", bootTest)
    waitFor sleepAsync(10000)