# SPDX-License-Identifier: MIT

import
  std / typetraits, preserves

type
  ErisBlock* {.preservesRecord: "erisx3".} = object
  
  ErisCache* {.preservesRecord: "erisx3-cache".} = object
  
proc `$`*(x: ErisBlock | ErisCache): string =
  `$`(toPreserve(x))

proc encode*(x: ErisBlock | ErisCache): seq[byte] =
  encode(toPreserve(x))
