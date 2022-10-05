# SPDX-License-Identifier: MIT

import
  std / asyncfutures

from std / sequtils import toSeq

import
  preserves, syndicate, syndicate / patterns

from syndicate / actors import preventInertCheck

from syndicate / protocols / dataspace import Observe

import
  ../eris

import
  ./private / syndicate_protocol

type
  Observe = dataspace.Observe[Ref]
proc fromPreserveHook*[E](bs: var BlockSize; pr: Preserve[E]): bool =
  if pr.isSymbol "a":
    bs = bs1k
    result = true
  elif pr.isSymbol "f":
    bs = bs32k
    result = true
  assert result, $pr

proc fromPreserveHook*[E](v: var Operations; pr: Preserve[E]): bool =
  if pr.isSet:
    result = true
    for pe in pr.set:
      if pe.isSymbol "Get":
        v.incl Get
      elif pe.isSymbol "Put":
        v.incl Put
      else:
        result = false

proc fromPreserveHook*[E](v: var Reference; pr: Preserve[E]): bool =
  if pr.kind == pkByteString and pr.bytes.len == v.bytes.len:
    copyMem(addr v.bytes[0], unsafeAddr pr.bytes[0], v.bytes.len)
    result = true

proc toPreserveHook*(bs: BlockSize; E: typedesc): Preserve[E] =
  case bs
  of bs1k:
    Preserve[E](kind: pkSymbol, symbol: Symbol"a")
  of bs32k:
    Preserve[E](kind: pkSymbol, symbol: Symbol"f")

proc toPreserveHook*(r: Reference; E: typedesc): Preserve[E] =
  ## Hook for preserving `Reference`.
  Preserve[E](kind: pkByteString, bytes: r.bytes.toSeq)

type
  SyndicateStore* {.final.} = ref object of ErisStoreObj
  
proc run(store: SyndicateStore; action: TurnAction) =
  ## Run an action in a new facet.
  store.facet.rundo (turn: var Turn):(discard facet(turn, action))

method get(store: SyndicateStore; futGet: FutureGet) =
  store.rundo (turn: var Turn):
    onPublish(turn, store.ds,
              ErisBlock ? {0: ?futGet.blockSize, 1: ?futGet.`ref`, 2: grab()})do (
        blk: seq[byte]):
      complete(futGet, blk)

method hasBlock(store: SyndicateStore; blkRef: Reference; bs: BlockSize): Future[
    bool] =
  let fut = newFuture[bool]("SyndicateStore.hasBlock")
  store.rundo (turn: var Turn):
    onPublish(turn, store.ds, ErisCache ? {0: ?bs, 1: ?blkRef}):
      fut.complete(true)
  fut

method put(store: SyndicateStore; futPut: FuturePut) =
  store.rundo (turn: var Turn):
    discard publish(turn, store.ds, ErisBlock(blockSize: futPut.blockSize,
        reference: futPut.`ref`, content: futPut.toBytes))
    onPublish(turn, store.ds,
              ErisCache ? {0: ?futPut.blockSize, 1: ?futPut.`ref`}):
      complete(futPut)

method close(store: SyndicateStore) =
  store.disarm()

proc newSyndicateStore*(turn: var Turn; ds: Ref; ops: Operations): SyndicateStore =
  var store = SyndicateStore(ds: ds)
  store.facet = turn.facetdo (turn: var Turn):
    store.disarm = turn.facet.preventInertCheck()
  store

proc addCallback*(fut: FutureBlock; turn: var Turn; act: TurnAction) =
  let facet = turn.facet
  fut.addCallback:
    run(facet, act)

proc newStoreFacet*(turn: var Turn; store: ErisStore; ds: Ref; ops = {Get, Put}): Facet =
  facet(turn)do (turn: var Turn):
    let
      blockRequest = Observe ?
          {0: ?ErisBlock ?? {0: ?DLit, 1: ?DLit, 2: drop()}}
      cacheRequest = Observe ? {0: ?ErisCache ?? {0: ?DLit, 1: ?DLit}}
    if Get in ops:
      during(turn, ds, blockRequest)do (bs: BlockSize; blkRef: Reference):
        var futGet = newFutureGet(blkRef, bs)
        futGet.addCallback(turn)do (turn: var Turn):
          if not futGet.failed:
            discard publish(turn, ds, ErisBlock(blockSize: futGet.blockSize,
                reference: futGet.`ref`, content: futGet.moveBytes))
        get(store, futGet)
    if Put in ops:
      during(turn, ds, cacheRequest)do (bs: BlockSize; blkRef: Reference):
        store.hasBlock(blkRef, bs).addCallback(turn)do (turn: var Turn;
            fut: Future[bool]):
          let hasBlock = fut.read
          if hasBlock:
            discard publish(turn, ds,
                            ErisCache(blockSize: bs, reference: blkRef))
          else:
            var pat = ErisBlock ? {0: ?bs, 1: ?blkRef, 2: grab()}
            onPublish(turn, ds, pat)do (blkBuf: seq[byte]):
              var futPut = newFuturePut(blkBuf)
              if futPut.`ref` == blkRef:
                futPut.addCallback(turn)do (turn: var Turn):(discard publish(
                    turn, ds, ErisCache(blockSize: futPut.blockSize,
                                        reference: futPut.`ref`)))
                put(store, futPut)
