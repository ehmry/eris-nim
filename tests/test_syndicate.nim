# SPDX-License-Identifier: MIT

import
  std / [asyncdispatch, json, streams, os, unittest]

import
  syndicate, syndicate / capabilities

import
  eris, eris / [memory_stores, syndicate_stores]

import
  ./vectors

proc unixSocketPath(): string =
  result = getEnv("SYNDICATE_SOCK")
  if result == "":
    result = getEnv("XDG_RUNTIME_DIR", "/run/user/1000") / "dataspace"

proc mintCap(): SturdyRef =
  var key: array[16, byte]
  mint(key, "syndicate")

const
  testString = "Hail ERIS!"
proc runTest(backend, frontend: ErisStore): Future[void] {.async.} =
  suite "get":
    for v in testVectors():
      test v:
        let cap = await backend.encode(v.cap.chunkSize, v.data.newStringStream,
                                       v.secret)
        check(cap == v.cap)
        let data = await frontend.decode(cap)
        check(cast[string](data) == v.data)
  suite "put":
    for v in testVectors():
      test v:
        let cap = await frontend.encode(v.cap.chunkSize, v.data.newStringStream,
                                        v.secret)
        check(cap == v.cap)
        let data = await backend.decode(cap)
        check(cast[string](data) == v.data)

proc bootTest(ds: Ref; turn: var Turn) =
  connectUnix(turn, unixSocketPath(), mintCap())do (turn: var Turn; ds: Ref):
    var
      backend = newMemoryStore()
      storeFacet = newStoreFacet(turn, backend, ds)
      frontend = newSyndicateStore(turn, ds, {Get, Put})
    asyncCheck runTest(backend, frontend)

suite "syndicate":
  if getEnv"NIX_BUILD_TOP" == "":
    bootDataspace("test", bootTest)
    waitFor sleepAsync(10000)