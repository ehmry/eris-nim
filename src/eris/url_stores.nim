# SPDX-License-Identifier: MIT

import
  std / [asyncdispatch, uri]

import
  ../eris, ./coap_stores, ./http_stores, ./composite_stores

proc newStoreClient*(url: Uri): Future[ErisStore] =
  case url.scheme
  of "http":
    result = http_stores.newStoreClient(url)
  of "coap+tcp":
    result = coap_stores.newStoreClient(url)
  else:
    result = newFuture[ErisStore]("newStoreClient")
    result.fail newException(ValueError, "unsupported URL scheme")

when defined(posix):
  import
    os

  from strutils import split

  proc newSystemStore*(): Future[MultiStore] {.async.} =
    ## Create a new `ErisStore` composed from the store URLs
    ## listed in the `ERIS_STORE_URL` environment variable.
    ## If `ERIS_STORE_URL` is empty then the returned `MultiStore`
    ## is also empty.
    var multi = newMultiStore()
    let urls = getEnv"ERIS_STORE_URL"
    for s in split(urls, ' '):
      if s != "":
        let
          u = parseUri(s)
          store = await newStoreClient(u)
        add(multi, store)
    return multi

  proc erisDecodeUrls*(): seq[string] =
    ## Return a list of URLs for ERIS decoding services.
    ## This list is taken from the environment variable `ERIS_DECODE_URL`.
    var s = getEnv("ERIS_DECODE_URL")
    if s != "":
      result = split(s, ' ')
