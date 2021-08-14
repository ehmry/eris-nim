# SPDX-License-Identifier: MIT

## ERIS stores backed by Tkrzw databases.
import
  std / asyncfutures, std / strutils

import
  tkrzw

import
  eris

export
  tkrzw.RW, tkrzw.OpenOption

type
  DbmStoreObj[T: tkrzw.DBM] {.final.} = object of ErisStoreObj
    dbm*: T

  DbmStore*[T] = ref DbmStoreObj[T]
proc dbmPut[T](s: ErisStore; r: Reference; b: seq[byte]): Future[void] =
  var s = DbmStore[T](s)
  s.dbm[r.bytes] = b
  result = newFuture[void]("dbmPut")
  result.complete()

proc dbmGet[T](s: ErisStore; r: Reference): Future[seq[byte]] =
  ## TODO: FutureVar for a reusable buffer
  var s = DbmStore[T](s)
  result = newFuture[seq[byte]]("dbmGet")
  try:
    result.complete(s.dbm[r.bytes])
  except:
    result.fail(newException(KeyError, "reference not in store"))

proc newDbmStore*[T](dbFilePath: string; rw = writeable;
                     opts: set[OpenOption] = {}): DbmStore[T] =
  ## Open a store using a hash hatabase backed by file.
  result = DbmStore[T](putImpl: dbmPut[T], getImpl: dbmGet[T],
                       dbm: newDBM[T](dbFilePath, rw, opts))

proc close*[T](ds: DbmStore[T]) =
  close(ds.dbm)
