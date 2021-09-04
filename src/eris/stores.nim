# SPDX-License-Identifier: MIT

import
  eris

import
  std / hashes, std / tables

import
  asyncdispatch, asyncfutures

type
  MemoryErisStore = ref MemoryErisStoreObj
  MemoryErisStoreObj = object of ErisStoreObj
  
proc memoryPut(s: ErisStore; r: Reference; f: PutFuture) =
  var s = MemoryErisStore(s)
  s.table[r] = f.mget
  complete f

proc memoryGet(s: ErisStore; r: Reference): Future[seq[byte]] =
  var s = MemoryErisStore(s)
  result = newFuture[seq[byte]]("memoryGet")
  try:
    result.complete(s.table[r])
  except:
    result.fail(newException(IOError, $r & " not found"))

proc newMemoryStore*(): MemoryErisStore =
  ## Create a new ``ErisStore`` that holds its content in-memory.
  MemoryErisStore(table: initTable[Reference, seq[byte]](), putImpl: memoryPut,
                  getImpl: memoryGet)
