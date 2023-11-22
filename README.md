![ERIS logo](./eris48.png "ERIS")
# ERIS

A collection of libraries and utilities for the [Encoding for Robust Immutable Storage](https://eris.codeberg.page).

The latest version of this repository should be available at [Codeberg](https://codeberg.org/eris/nim-eris).

## Building

### Debian

The Debian is too old and crusty to support.

The Nix way:
``` sh
# https://nixos.org/download.html#download-nix
$ sh <(curl -L https://nixos.org/nix/install) --no-daemon
$ nix-env -iA nixpkgs.gitMinimal
$ nix-env -iA eriscmd -f https://codeberg.org/eris/nix-eris/archive/trunk.tar.gz
```

The Debian way:
- Install pkg-config
- Build and install the current Nim compiler and the Nimble utility from source.
- Build and install the [tkrzw library](https://dbmx.net/tkrzw/) from source.
- Build and install the [getdns library](https://getdnsapi.net/) from source.
- Run `nimble install https://codeberg.org/eris/nim-eris.git`.
- Probably do some other stuff but you are Debian user so you should be able to manage on your own.

## eriscmd

`eriscmd` is a utility program with a bunch of subcommands. They are mostly self-describing.

### link

The `eriscmd link` utility creates [ERIS link files](https://codeberg.org/eris/eer/pulls/15) from ERIS URNs.
A URN is read from stdin or passed as an argument an a link file is written to stdout.

This utility requires the location of an ERIS CoAP server which should be passed with the environmental variable `ERIS_STORE_URL`.

A simple example:
```sh
$ ERIS_STORE_URL="coap+tcp://[::1]:5683"
$ pv ./some.data | eris-go put --convergent "$ERIS_STORE_URL" | eriscmd link > some.data.eris
```

### linkedit

Replace the MIME-type and metadata of ERIS­link files.

### open

The `eriscmd open` utility opens [ERIS link files](https://eris.codeberg.page/eer/linkfile.xml) in an application that is locally configured for the given MIME type of the link file. To integrate it within a [Freedesktop.org](https://www.freedesktop.org/) environment the [eris-open.desktop](./eris-open.desktop), [eris-link.xml](./eris-link.xml), and [eris48.png](./eris48.png) should be installed in their appropriate locations.

The utility only works as well as the associations that are configured for different MIME types, see the `xdg-mime` utility from [xdg-utils](https://freedesktop.org/wiki/Software/xdg-utils/) for more information.

The utility requires a configuration file that describes the location of the preferred HTTP decoder service. The file is called `eris-open.ini` and must be located in the `XDG_CONFIG_HOME` `XDG_CONFIG_DIRS` hierarchy (`~./config/` is good enough).

A simple example:
```ini
[Decoder]
URL=http://[::1]:80
```

### verify

The `eriscmd verify` utility will fetch all blocks that constitute a read capability. It parses capabilities on the command-line in URN form and otherwise parses CBOR on standard input to find capabilities.

```sh
eriscmd verify urn:eris:BIAMSY42PLVLXF2GQAVOONCNWPEU2PLOYXZXAVFZIRVACKI424N24CMJPPRK7QNWH3LNRE7Q3ENOAJWPKCNUJOLCHIWSEOO6RW5KH7MJ2A

cat *.eris | eriscmd verify
```

## Helpers

### rclerislink

The `rclerislink` utility is a document input handler for the [Recoll](https://www.recoll.org/) indexer that allows [ERIS link file](https://eris.codeberg.page/eer/linkfile.xml) content to be dereferenced and indexed.

This input handler  needs to be registered in the `~/.recoll/mimeconf` file so that it is invoked for the `application/x-eris-link+cbor` file MIME type. For detection of this MIME type to work the [eris-link.xml](./eris-link.xml) file should be installed in a location where it is discoverable by `xdg-mime query filetype …`.
```
[index]
application/x-eris-link+cbor = execm /some/path/to/rclerislink

```

## Nix development

```sh
nix develop git+https://codeberg.org/eris/nix-eris#nim-eris
```

---

The drafting of the ERIS specification and this implementation was funded by the [NGI Assure](https://nlnet.nl/assure) Fund, a fund established by [NLnet](https://nlnet.nl/) with financial support from the European Commission's [Next Generation Internet](https://ngi.eu/) program.

[![NGIAssure](https://nlnet.nl/image/logos/NGIAssure_tag.svg)](https://nlnet.nl/assure)
