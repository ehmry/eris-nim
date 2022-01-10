# ⯰ ERIS

See the [spec](https://eris.codeberg.page/spec/) for more information.

The latest version of this library should be available at
https://codeberg.org/eris/nim-eris

## Test

```
nimble develop https://git.sr.ht/~ehmry/eris
cd eris
git submodule init
git submodule update

nim c -d:release -r test/test_small
nim c -d:release -r test/test_large
```

## Todo
* Optimise the Chacha20 and BLAKE2 primatives
* Split unpure modules (TKRZW) to separate libraries
