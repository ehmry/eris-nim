# Package

version       = "0.4.1"
author        = "Emery Hemingway"
description   = "Utilities for working with the Encoding for Robust Immutable Storage (ERIS)"
license       = "Unlicense"
srcDir        = "src"
bin           = @["eriscat", "erisencode", "erisdb", "erisdbmerge", "erishttpd", "erissum"]
backend       = "cpp"


# Dependencies

requires "nim >= 1.4.2", "eris >= 0.6.0", "tkrzw >= 0.1.2"
