# SPDX-License-Identifier: MIT

## ERIS stores backed by Tkrzw databases.
import
  std / asyncfutures

import
  tkrzw

import
  ../eris

export
  tkrzw.RW, tkrzw.OpenOption

type
  DbmStore* {.final.} = ref object of ErisStoreObj
    dbm*: HashDBM
  
method id(s: DbmStore): string =
  "tkrzw+file://" & s.path

method get(s: DbmStore; fut: FutureGet) =
  assert not fut.verified
  if Get notin s.ops:
    fail(fut, newException(IOError, "get denied"))
  elif s.dbm.get(fut.`ref`.bytes.toStringView, fut.buffer, fut.blockSize.int):
    assert not fut.verified
    verify(fut)
    complete(fut)
  else:
    notFound(fut, "reference not in database file")

method hasBlock(store: DbmStore; r: Reference; bs: BlockSize): Future[bool] =
  result = newFuture[bool]("DbmStore.hasBlock")
  try:
    result.complete(store.dbm.hasKey r.bytes)
  except:
    result.fail getCurrentException()

method put(s: DbmStore; fut: FuturePut) =
  if Put notin s.ops:
    fail(fut, newException(IOError, "put denied"))
  s.dbm.set(toStringView(fut.`ref`.bytes),
            toStringView(fut.buffer, fut.blockSize.int), false)
  complete(fut)

method close(ds: DbmStore) =
  close(ds.dbm)

proc newDbmStore*(dbFilePath: string; ops = {Get, Put};
                  opts: set[OpenOption] = {}): DbmStore =
  ## Open a store using a hash hatabase backed by file.
  var
    rw = if Put in ops:
      writeable else:
      readonly
    dbm = newDBM[HashDBM](dbFilePath, rw, opts)
  DbmStore(path: dbFilePath, dbm: dbm, ops: ops)
