# SPDX-License-Identifier: MIT

import
  blake2

import
  json, strutils, unittest

test "simple":
  check(getBlake2b("abc", 4, "abc") == "b8f97209")
  check(getBlake2b("", 4, "abc") == "8ef2d47e")
  check(getBlake2b("abc", 4) == "63906248")
  check(getBlake2b("", 4) == "1271cf25")
  var b1, b2: Blake2b
  init(b1, 4)
  init(b2, 4)
  update(b1, @[97'u8])
  update(b1, @[98'u8])
  update(b1, @[99'u8])
  update(b2, @[97'u8, 98'u8, 99'u8])
  check(final(b1) == final(b2))
let js = parseFile("tests/blake2-kat.json")
iterator testVectors(hash: string): tuple[input, key, output: seq[byte]] =
  var input, key, output: seq[byte]
  for test in js.items:
    if test["hash"].getStr == hash:
      input = cast[seq[byte]](test["in"].getStr.parseHexStr)
      key = cast[seq[byte]](test["key"].getStr.parseHexStr)
      output = cast[seq[byte]](test["out"].getStr.parseHexStr)
      yield (input, key, output)

test "blake2b":
  var ctx: Blake2b
  for (input, key, output) in testVectors("blake2b"):
    check(getBlake2b(input, 64, key) == output)
    init(ctx, 64, key)
    update(ctx, input)
    check(final(ctx) == output)