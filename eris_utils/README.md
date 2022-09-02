# Utilities for the Encoding for Robust Immutable Storage (ERIS)

## Build

Requires a recent version of the [Nim](https://nim-lang.org/) compiler
and the Nimble utility.
```sh
nimble install https://git.sr.ht/~ehmry/eris_utils
export PATH="$PATH:$HOME/.nimble/bin"
```
## Develop

```sh
nix develop git+https://codeberg.org/eris/nix-eris#nim-eris_utils
```

## Usage

A utility `eriscmd` with a bunch of subcommands. They should be self describing except for `resolver`.

### resolver

The `eris resolver` utility that resolves block traffic between the following:
  - CoAP clients
  - CoAP servers
  - HTTP clients (see [ERIS over HTTP](https://eris.codeberg.page/eer/eer-001/))
  - HTTP servers
  - [tkrzw](https://dbmx.net/tkrzw/) database files
  - Syndicate actors ([protocol](https://codeberg.org/eris/nim-eris/src/branch/trunk/syndicate_protocol.prs))

The server configuration is inspired by [Genode](https://genode.org/)'s [dynamic component reconfiguration](https://genode.org/documentation/genode-foundations/21.05/components/Component_configuration.html) and implemented by the [Syndicated actor model](https://syndicate-lang.org). The server cannot be excuted normally, it must be supervised by a [Syndicate server](https://synit.org/book/operation/system-bus.html). The configuration schema is at [erisresolver_config.prs](./erisresolver_config.prs) and sample is at [erisresolver.config.sample.pr](./erisresolver.config.sample.pr).

If you are using UNIX you will need to ask a system administrator or a grownup that you trust to remove the restriction on binding to port 80. This is can be done with `sysctl`:
```sh
doas sysctl net.ipv6.ip_unprivileged_port_start=80
```
