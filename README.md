# Utilities for the Encoding for Robust Immutable Storage (ERIS)

## Build

Requires a recent version of the [Nim](https://nim-lang.org/) compiler
and the Nimble utility.
```sh
nimble install https://git.sr.ht/~ehmry/eris_utils
export PATH="$PATH:$HOME/.nimble/bin"
```


## Usage

### eriscat

```
Usage: eriscat FILE [FILE …]

Concatenate files to a stream with padding between ERIS block boundaries.
If the average file size is less than 16KiB then the output stream is padded to
align to 1KiB blocks, otherwise 32KiB.

This utility is intending for joining files in formats that support
concatenation such as Ogg containers. The resulting stream can be mostly
deduplicated with the individual encodings of each file.
```

### erisencode

```
Usage: erissum [OPTION]... FILE [URI]...
Encode or decode a file containing ERIS blocks.

When URIs are supplied then data is read from FILE to stdout,
otherwise data from stdin is written to FILE and a URN is
written to stdout.

  --1k           1KiB block size
  --32k         32KiB block size (default)

If FILE has already been initialized then its block size
will override the requested block size.
```

### erisdb

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

### erisdbmerge

```
Usage: erisdbmerge DESTINATION_DB +SOURCE_DB
Merge ERIS block databases.

The first database file passed on the commandline is
open and the contents of successive database files are
copied into it.

```

### erishttpd

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

### ersissum

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
