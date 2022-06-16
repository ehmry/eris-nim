# SPDX-License-Identifier: MIT

import
  std / typetraits, preserves

type
  HttpServer* {.preservesRecord: "eris-http-server".} = object
  
  ErisNeighbor* {.preservesRecord: "eris-neighbor".} = object
  
  CoapServer* {.preservesRecord: "eris-coap-server".} = object
  
  `Op`* {.preservesOr, pure.} = enum
    `Get`, `Put`
  Ops* = set[Op]
proc `$`*(x: HttpServer | ErisNeighbor | CoapServer | Ops): string =
  `$`(toPreserve(x))

proc encode*(x: HttpServer | ErisNeighbor | CoapServer | Ops): seq[byte] =
  encode(toPreserve(x))
