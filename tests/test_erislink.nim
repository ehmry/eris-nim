# SPDX-License-Identifier: MIT

import
  std /
      [asyncdispatch, json, os, parseopt, sets, streams, strutils, tempfiles,
       unittest]

import
  cbor, eris, eris / cbor_stores, eris / memory_stores

import
  eris / eriscmd / erislink

import
  eris / test_vectors

suite "erislink":
  var
    file: File
    dataPath, linkPath: string
    nullSecret: Secret
  setup:
    (file, dataPath) = createTempFile(v.id, ".tmp")
    linkPath = dataPath & ".eris"
  teardown:
    close(file)
    removeFile(linkPath)
    removeFile(dataPath)
  for v in testVectors():
    test v:
      if getEnv("ERIS_STORE_URL") == "":
        echo "ERIS_STORE_URL is empty"
        skip()
      elif v.secret != nullSecret:
        skip()
      else:
        write(file, v.data)
        flushFile(file)
        var cmd = "--quiet --convergent --mime:text/plain -o:" & linkPath & " " &
            dataPath
        case v.cap.chunkSize
        of chunk1k:
          add(cmd, " --1k")
        of chunk32k:
          add(cmd, " --32k")
        var opts = initOptParser(cmd)
        check erislink.main(opts) == ""
        var
          linkStream = openFileStream(linkPath)
          link = readCbor(linkStream)
        var cap: ErisCap
        check fromCborHook(cap, link.seq[0])
        check cap == v.cap