# ⯰ ERIS

A collection of libraries and utilities for the [Encoding for Robust Immutable Storage](https://eris.codeberg.page).

The latest version of this repository should be available at [Codeberg](https://codeberg.org/eris/nim-eris).

## Develop

```sh
nix develop git+https://codeberg.org/eris/nix-eris#nim-eris
```

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
doas sysctl net.ipv6.ip_unprivileged_port_start=80
```
