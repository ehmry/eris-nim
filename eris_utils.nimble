# Package

version = "20220831"
author        = "Emery Hemingway"
description   = "Utilities for working with the Encoding for Robust Immutable Storage (ERIS)"
license       = "Unlicense"
srcDir        = "src"
bin           = @["eriscmd"]
backend       = "cpp"


# Dependencies

requires "nim >= 1.6.0", "eris >= 20220831"
