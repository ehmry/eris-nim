# Package

version       = "0.6.0"
author        = "Emery Hemingway"
description   = "Encoding for Robust Immutable Storage"
license       = "ISC"
srcDir        = "src"
backend       = "cpp"


# Dependencies

requires "nim >= 1.4.0", "base32 >= 0.1.3", "taps >= 0.2.0", "tkrzw >= 0.1.2"

import distros
if detectOs(NixOS):
  foreignDep "tkrzw"
