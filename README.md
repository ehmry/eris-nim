# Utilities for the Encoding for Robust Immutable Storage (ERIS)

Try it with Nix: `nix shell nimble#eris_utils`

## erisdb

```
Usage: erisdb [OPTION]... [URI]...
Read and write ERIS encoded content to a file-backed database.

The locataion of the database file is configured by the "eris_db_file"
environment variable.

Each URI specified is written to stdout. If no URIs are specified then
read standard input into the database and print the corresponding URI.

  --1k    1KiB block size
  --32k  32KiB block size (default)

```

## erishttpd

```
Usage: erishttpd [OPTION]…
GET and PUT data to an ERIS store over HTTP.

Command line arguments:

  --port:…  HTTP listen port

  --get     Enable downloads using GET requests
  --head    Enable queries using HEAD requests
  --put     Enable uploading using PUT requests

The location of the database file is configured by the "eris_db_file"
environment variable.

Files may be uploaded using cURL:
curl -i --upload-file <FILE> http://[::1]:<PORT>
```

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
