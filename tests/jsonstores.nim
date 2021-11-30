# SPDX-License-Identifier: MIT

import
  eris

import
  base32

import
  std / json

import
  asyncdispatch, asyncfutures

type
  JsonStore = ref JsonStoreObj
  JsonStoreObj = object of ErisStoreObj
  
method get(s: JsonStore; r: Reference): Future[seq[byte]] =
  result = newFuture[seq[byte]]("jsonGet")
  try:
    result.complete(cast[seq[byte]](base32.decode(s.js["blocks"][$r].getStr)))
  except:
    result.fail(newException(IOError, $r & " not found"))

proc newJsonStore*(js: JsonNode): JsonStore =
  new(result)
  result.js = js
