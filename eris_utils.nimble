# Package

version       = "0.1.2"
author        = "Emery Hemingway"
description   = "Utilities for working with the Encoding for Robust Immutable Storage (ERIS)"
license       = "GPL-3.0"
srcDir        = "src"
bin           = @["erissum"]


# Dependencies

requires "nim >= 1.4.2", "eris >= 0.3.0"
