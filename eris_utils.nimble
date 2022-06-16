# Package

version = "20220616"
author        = "Emery Hemingway"
description   = "Utilities for working with the Encoding for Robust Immutable Storage (ERIS)"
license       = "Unlicense"
srcDir        = "src"
bin           = @["eriscat", "erisencode", "erisdb", "erisdbmerge", "erishttpd", "erisresolver", "erissum", "eris_coap_client", "eris_db_actor", "eris_syndicate"]
backend       = "cpp"


# Dependencies

requires "nim >= 1.4.2", "eris >= 0.4.2", "eris_tkrzw >= 0.4.0", "eris_protocols >= 0.4.2", "syndicate"
