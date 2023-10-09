# Package

version = "20231009"
author        = "Endo Renberg"
description   = "Encoding for Robust Immutable Storage"
license       = "Unlicense"
srcDir        = "src"
backend       = "cpp"
bin           = @["eris/eriscmd", "eris/helpers/rclerislink"]


# Dependencies

requires "nim >= 2.0.0", "base32 >= 0.1.3", "https://codeberg.org/eris/nim-coap.git >= 20220831", "git+https://git.sr.ht/~ehmry/nim_cbor", "git+https://git.sr.ht/~ehmry/nim_taps", "git+https://git.sr.ht/~ehmry/freedesktop_org >= 20230201", "git+https://git.sr.ht/~ehmry/nim-tkrzw >= 20220910", "illwill"
