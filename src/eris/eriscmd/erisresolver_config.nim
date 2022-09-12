# SPDX-License-Identifier: MIT

import
  std / typetraits, preserves

type
  HttpServer* {.preservesRecord: "http-server".} = object
  
  `BlockSize`* {.preservesOr, pure.} = enum
    `a`, `f`
  ErisBlock* {.preservesRecord: "eris-block".} = object
  
  Peer* {.preservesRecord: "peer".} = object
  
  SyndicateRelay*[E] {.preservesRecord: "syndicate".} = ref object
  
  FileIngester*[E] {.preservesRecord: "ingester".} = ref object
  
  TkrzwDatabase* {.preservesRecord: "tkrzw".} = object
  
  ErisCapability* {.preservesRecord: "eris".} = object
  
  CoapServer* {.preservesRecord: "coap-server".} = object
  
  ErisCache* {.preservesRecord: "eris-cache".} = object
  
  `SecretMode`* {.preservesOr, pure.} = enum
    `convergent`, `unique`
  `Op`* {.preservesOr, pure.} = enum
    `Get`, `Put`
  Ops* = set[Op]
proc `$`*[E](x: SyndicateRelay[E] | FileIngester[E]): string =
  `$`(toPreserve(x, E))

proc encode*[E](x: SyndicateRelay[E] | FileIngester[E]): seq[byte] =
  encode(toPreserve(x, E))

proc `$`*(x: HttpServer | ErisBlock | Peer | TkrzwDatabase | ErisCapability |
    CoapServer |
    ErisCache |
    Ops): string =
  `$`(toPreserve(x))

proc encode*(x: HttpServer | ErisBlock | Peer | TkrzwDatabase | ErisCapability |
    CoapServer |
    ErisCache |
    Ops): seq[byte] =
  encode(toPreserve(x))
