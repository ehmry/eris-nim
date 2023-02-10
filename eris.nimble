# Package

version = "20230210"
author        = "Endo Renberg"
description   = "Encoding for Robust Immutable Storage"
license       = "Unlicense"
srcDir        = "src"
backend       = "cpp"
bin           = @["eris/eriscmd"]


# Dependencies

requires "nim >= 1.4.0", "base32 >= 0.1.3", "https://codeberg.org/eris/nim-coap.git >= 20220831", "cbor", "coap >= 20220924", "freedesktop_org >= 20230201", "syndicate >= 20220904", "tkrzw >= 20220910"
