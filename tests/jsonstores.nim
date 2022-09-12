# SPDX-License-Identifier: MIT

import
  eris

import
  base32

import
  std / json

type
  JsonStore = ref JsonStoreObj
  JsonStoreObj = object of ErisStoreObj
  
method get(s: JsonStore; blk: FutureGet) =
  try:
    complete(blk, cast[seq[byte]](base32.decode(
        s.js["blocks"][$blk.`ref`].getStr)), BlockStatus.verified)
  except:
    fail(blk, newException(IOError, $blk.`ref` & " not found"))

proc newJsonStore*(js: JsonNode): JsonStore =
  new(result)
  result.js = js
