let Listener/Type = { host : Text, port : Natural }

let Ingest/Type = { cap : Optional Text, path : Text }

let ErisServer/Type =
      { ingests : List Ingest/Type, listeners : List Listener/Type }

in  { Type = ErisServer/Type }
