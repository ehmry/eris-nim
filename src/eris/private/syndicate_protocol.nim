# SPDX-License-Identifier: MIT

import
  std / typetraits, preserves, ../../eris

type
  ErisBlock* {.preservesRecord: "eris-block".} = object
  
  ErisCapability* {.preservesRecord: "eris".} = object
  
  ErisCache* {.preservesRecord: "eris-cache".} = object
  
  `SecretMode`* {.preservesOr, pure.} = enum
    `convergent`, `unique`
proc `$`*(x: ErisBlock | ErisCapability | ErisCache): string =
  `$`(toPreserve(x))

proc encode*(x: ErisBlock | ErisCapability | ErisCache): seq[byte] =
  encode(toPreserve(x))
