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

`eriscmd` is a utility program with a bunch of subcommands. They should be self describing except for `resolver`.

### resolver

The `eris resolver` utility that resolves ERIS blocks between the following:
  - [CoAP](https://en.wikipedia.org/wiki/Constrained_Application_Protocol) clients
  - CoAP servers
  - HTTP clients (see [ERIS over HTTP](https://eris.codeberg.page/eer/eer-001/))
  - HTTP servers
  - [tkrzw](https://dbmx.net/tkrzw/) database files
  - [Syndicate](https://syndicate-lang.org) [actors](./protocols/syndicate_protocol.prs)

The server configuration is inspired by [Genode](https://genode.org/)'s [dynamic component reconfiguration](https://genode.org/documentation/genode-foundations/21.05/components/Component_configuration.html) and implemented by the Syndicated actor model. The server cannot be excuted normally, it must be supervised by a [Syndicate server](https://synit.org/book/operation/system-bus.html). The configuration schema is at [erisresolver_config.prs](./protocols/erisresolver_config.prs) and sample is at [erisresolver.config.sample.pr](./erisresolver.config.sample.pr).

If you are using UNIX you will need to ask a system administrator or a grownup that you trust to remove the restriction on binding to port 80. This is can be done with `sysctl`:
```sh
doas sysctl net.ipv4.ip_unprivileged_port_start=80
```

## Nix development

```sh
nix develop git+https://codeberg.org/eris/nix-eris#nim-eris
```

---

The drafting of the ERIS specification and this implementation was funded by the [NGI Assure](https://nlnet.nl/assure) Fund, a fund established by [NLnet](https://nlnet.nl/) with financial support from the European Commission's [Next Generation Internet](https://ngi.eu/) program.

[![NGIAssure](https://nlnet.nl/image/logos/NGIAssure_tag.svg)](https://nlnet.nl/assure)
