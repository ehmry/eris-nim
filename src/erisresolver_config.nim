# SPDX-License-Identifier: MIT

import
  std / typetraits, preserves

from eris import Operations

type
  HttpServer* {.preservesRecord: "http-server".} = object
  
  CoapClient* {.preservesRecord: "http-client".} = object
  
  SyndicateRelay*[E] {.preservesRecord: "syndicate".} = ref object
  
  TkrzwDatabase* {.preservesRecord: "tkrzw".} = object
  
  CoapServer* {.preservesRecord: "coap-server".} = object
  
  HttpClient* {.preservesRecord: "http-client".} = object
  
proc `$`*[E](x: SyndicateRelay[E]): string =
  `$`(toPreserve(x, E))

proc encode*[E](x: SyndicateRelay[E]): seq[byte] =
  encode(toPreserve(x, E))

proc `$`*(x: HttpServer | CoapClient | TkrzwDatabase | CoapServer | Operations |
    HttpClient): string =
  `$`(toPreserve(x))

proc encode*(x: HttpServer | CoapClient | TkrzwDatabase | CoapServer |
    Operations |
    HttpClient): seq[byte] =
  encode(toPreserve(x))
