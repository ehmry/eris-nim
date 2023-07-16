# Package

version = "20230716"
author        = "Endo Renberg"
description   = "Encoding for Robust Immutable Storage"
license       = "Unlicense"
srcDir        = "src"
backend       = "cpp"
bin           = @["eris/eriscmd", "eris/helpers/rclerislink"]


# Dependencies

requires "nim >= 1.4.0", "base32 >= 0.1.3", "https://codeberg.org/eris/nim-coap.git >= 20220831", "cbor", "coap >= 20220924", "freedesktop_org >= 20230201", "syndicate >= 20230518", "tkrzw >= 20220910"
