# SPDX-License-Identifier: MIT

import
  std / [asyncdispatch, asyncfutures, hashes, tables]

import
  eris

type
  MemoryErisStore = ref MemoryErisStoreObj
  MemoryErisStoreObj = object of ErisStoreObj
  
method put(s: MemoryErisStore; r: Reference; f: PutFuture) =
  s.table[r] = f.mget
  complete f

method get(s: MemoryErisStore; r: Reference): Future[seq[byte]] =
  result = newFuture[seq[byte]]("memoryGet")
  try:
    result.complete(s.table[r])
  except:
    result.fail(newException(IOError, $r & " not found"))

method hasBlock(s: MemoryErisStore; r: Reference): Future[bool] =
  result = newFuture[bool]("DiscardStore.hasBlock")
  result.complete(s.table.hasKey r)

proc newMemoryStore*(): MemoryErisStore =
  ## Create a new ``ErisStore`` that holds its content in-memory.
  MemoryErisStore(table: initTable[Reference, seq[byte]]())
