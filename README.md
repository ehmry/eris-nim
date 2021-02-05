# Utilities for the Encoding for Robust Immutable Storage (ERIS)

Try it with Nix: `nix shell nimble#eris_utils`

## ersissum

```
Usage: erissum [OPTION]... [FILE]...
Print ERIS capabilities.

With no FILE, or when FILE is -, read standard input.

  --1k         1KiB block size
  --32k       32KiB block size (default)

  -t, --tag    BSD-style output
  -z, --zero   GNU-style output with zero-terminated lines
  -j, --json  JSON-style output

Default output format is GNU-style.

```
