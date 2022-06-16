# SPDX-License-Identifier: MIT

import
  std / typetraits, preserves

type
  TkrzwFile*[E] {.preservesRecord: "tkrzw".} = ref object
  
  `Op`* {.preservesOr, pure.} = enum
    `Get`, `Put`
  Ops* = set[Op]
proc `$`*[E](x: TkrzwFile[E]): string =
  `$`(toPreserve(x, E))

proc encode*[E](x: TkrzwFile[E]): seq[byte] =
  encode(toPreserve(x, E))

proc `$`*(x: Ops): string =
  `$`(toPreserve(x))

proc encode*(x: Ops): seq[byte] =
  encode(toPreserve(x))
