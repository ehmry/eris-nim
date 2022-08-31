# SPDX-License-Identifier: MIT

import
  std / [asyncfutures, uri]

import
  ../eris, ./coap_stores, ./http_stores

proc newStoreClient*(url: Uri): Future[ErisStore] =
  case url.scheme
  of "http":
    result = http_stores.newStoreClient(url)
  of "coap+tcp":
    result = coap_stores.newStoreClient(url)
  else:
    result = newFuture[ErisStore]("newStoreClient")
    result.fail newException(ValueError, "unsupported URL scheme")
