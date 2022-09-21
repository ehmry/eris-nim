# Package

version = "20220921"
author        = "Endo Renberg"
description   = "Encoding for Robust Immutable Storage"
license       = "Unlicense"
srcDir        = "src"
backend       = "cpp"
bin           = @["eris/eriscmd"]


# Dependencies

requires "nim >= 1.4.0", "base32 >= 0.1.3", "cbor >= 20220831", "coap >= 20220913", "syndicate >= 20220904", "tkrzw >= 20220910"
