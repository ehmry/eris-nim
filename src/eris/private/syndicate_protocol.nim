# SPDX-License-Identifier: MIT

import
  preserves

type
  ErisCapability* {.preservesRecord: "eris".} = object
  
  `ChunkSize`* {.preservesOr, pure.} = enum
    `a`, `f`
  ErisCache* {.preservesRecord: "eris-cache".} = object
  
  `SecretMode`* {.preservesOr, pure.} = enum
    `convergent`, `unique`
  ErisChunk* {.preservesRecord: "eris-chunk".} = object
  
proc `$`*(x: ErisCapability | ErisCache | ErisChunk): string =
  `$`(toPreserve(x))

proc encode*(x: ErisCapability | ErisCache | ErisChunk): seq[byte] =
  encode(toPreserve(x))
