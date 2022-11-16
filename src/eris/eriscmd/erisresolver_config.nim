# SPDX-License-Identifier: MIT

import
  std / typetraits, preserves

type
  HttpServer* {.preservesRecord: "http-server".} = object
  
  Peer* {.preservesRecord: "peer".} = object
  
  SyndicateRelay*[E] {.preservesRecord: "syndicate".} = ref object
  
  FileIngester*[E] {.preservesRecord: "ingester".} = ref object
  
  TkrzwDatabase* {.preservesRecord: "tkrzw".} = object
  
  ErisCapability* {.preservesRecord: "eris".} = object
  
  `ChunkSize`* {.preservesOr, pure.} = enum
    `a`, `f`
  CoapServer* {.preservesRecord: "coap-server".} = object
  
  ErisCache* {.preservesRecord: "eris-cache".} = object
  
  `SecretMode`* {.preservesOr, pure.} = enum
    `convergent`, `unique`
  `Op`* {.preservesOr, pure.} = enum
    `Get`, `Put`
  Ops* = set[Op]
  ErisChunk* {.preservesRecord: "eris-chunk".} = object
  
proc `$`*[E](x: SyndicateRelay[E] | FileIngester[E]): string =
  `$`(toPreserve(x, E))

proc encode*[E](x: SyndicateRelay[E] | FileIngester[E]): seq[byte] =
  encode(toPreserve(x, E))

proc `$`*(x: HttpServer | Peer | TkrzwDatabase | ErisCapability | CoapServer |
    ErisCache |
    Ops |
    ErisChunk): string =
  `$`(toPreserve(x))

proc encode*(x: HttpServer | Peer | TkrzwDatabase | ErisCapability | CoapServer |
    ErisCache |
    Ops |
    ErisChunk): seq[byte] =
  encode(toPreserve(x))
