# SPDX-License-Identifier: MIT

import
  std / asyncdispatch

import
  syndicate

import
  eris, eris_tkrzw / filedbs, eris_protocols / syndicate_protocol

import
  ./eris_db_actor_config

bootDataspace("main")do (root: Ref; turn: var Turn):
  connectStdio(root, turn)
  during(turn, root, ?TkrzwFile[Ref])do (path: string; ops: Operations; ds: Ref):
    let
      store = newDbmStore(path, ops)
      facet = newStoreFacet(turn, store, ds)
  do:
    stop(turn, facet)
    close(store)
runForever()