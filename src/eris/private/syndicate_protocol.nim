# SPDX-License-Identifier: MIT

import
  std / typetraits, preserves, eris

type
  ErisBlock* {.preservesRecord: "eris-block".} = object
  
  ErisCache* {.preservesRecord: "eris-cache".} = object
  
proc `$`*(x: ErisBlock | ErisCache): string =
  `$`(toPreserve(x))

proc encode*(x: ErisBlock | ErisCache): seq[byte] =
  encode(toPreserve(x))
