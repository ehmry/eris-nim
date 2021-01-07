# SPDX-License-Identifier: MIT

import
  eris

import
  base32

import
  json

type
  JsonStore = ref JsonStoreObj
  JsonStoreObj = object of StoreObj
  
proc jsonGet(s: Store; r: Reference): seq[byte] =
  var s = JsonStore(s)
  try:
    cast[seq[byte]](base32.decode(s.js["blocks"][$r].getStr))
  except:
    raise newException(IOError, $r & " not found")

proc newJsonStore*(js: JsonNode): JsonStore =
  new(result)
  result.js = js
  result.getImpl = jsonGet
