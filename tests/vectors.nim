# SPDX-License-Identifier: MIT

import
  std / [json, os, unittest]

import
  base32

import
  eris

proc findVectorsDir(): string =
  var parent = getCurrentDir()
  while result != "/":
    result = parent / "test-vectors"
    if dirExists result:
      return
    parent = parent.parentDir
  raiseAssert "Could not find test vectors"

type
  TestVector* = tuple[js: JsonNode, urn: string, cap: ErisCap, secret: Secret,
                      data: string]
template test*(v: TestVector; body: untyped): untyped =
  test $v.js["id"]:
    checkpoint v.js["description"].getStr
    body

iterator testVectors*(): TestVector =
  for path in walkPattern(findVectorsDir() / "*.json"):
    let
      js = parseFile(path)
      urn = js["urn"].getStr
      cap = parseErisUrn(urn)
      secret = parseSecret(js["convergence-secret"].getStr)
      data = base32.decode(js["content"].getStr)
    yield (js, urn, cap, secret, data)
