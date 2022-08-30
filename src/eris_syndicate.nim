# SPDX-License-Identifier: MIT

import
  std / asyncdispatch

from std / os import `/`, commandLineParams, getEnv

from std / streams import newFileStream

{.error: "put and get".}
import
  syndicate, syndicate / capabilities

import
  eris, eris / syndicate_stores

proc unixSocketPath(): string =
  result = getEnv("SYNDICATE_SOCK")
  if result == "":
    result = getEnv("XDG_RUNTIME_DIR", "/run/user/1000") / "dataspace"

proc mintCap(): SturdyRef =
  var key: array[16, byte]
  mint(key, "erisx3")

proc dump(store: SyndicateStore; caps: seq[ErisCap]) {.async.} =
  var stream = newFileStream(stdout)
  for cap in caps:
    var eris = newErisStream(store, cap)
    await dump(eris, stream)
    close(eris)

proc main(): Actor =
  var caps = newSeq[ErisCap]()
  for param in commandLineParams():
    try:
      caps.add parseErisUrn param
    except:
      quit "failed to parse " & param & " as ERIS URN"
  bootDataspace("main")do (root: Ref; turn: var Turn):
    let rootFacet = turn.facet
    connectUnix(turn, unixSocketPath(), mintCap())do (turn: var Turn; ds: Ref):
      if caps == @[]:
        let store = newSyndicateStore(turn, ds, {Put})
        encode(store, newFileStream(stdin)).addCallbackdo (fut: Future[ErisCap]):
          stdout.writeLine(fut.read)
          rootFacet.rundo (turn: var Turn):
            stop(turn)
      else:
        let store = newSyndicateStore(turn, ds, {Get})
        dump(store, caps).addCallbackdo (fut: Future[void]):
          rootFacet.rundo (turn: var Turn):
            fut.read()
            stop(turn)

waitFor main().future