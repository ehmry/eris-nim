# SPDX-License-Identifier: MIT

import
  std / typetraits, preserves

from ../../eris import Operations

type
  HttpServer* {.preservesRecord: "http-server".} = object
  
  Peer* {.preservesRecord: "peer".} = object
  
  SyndicateRelay*[E] {.preservesRecord: "syndicate".} = ref object
  
  TkrzwDatabase* {.preservesRecord: "tkrzw".} = object
  
  CoapServer* {.preservesRecord: "coap-server".} = object
  
proc `$`*[E](x: SyndicateRelay[E]): string =
  `$`(toPreserve(x, E))

proc encode*[E](x: SyndicateRelay[E]): seq[byte] =
  encode(toPreserve(x, E))

proc `$`*(x: HttpServer | Peer | TkrzwDatabase | CoapServer | Operations): string =
  `$`(toPreserve(x))

proc encode*(x: HttpServer | Peer | TkrzwDatabase | CoapServer | Operations): seq[
    byte] =
  encode(toPreserve(x))
