# Cbox Homebrew tap

Formulae for Cbox tools.

```bash
brew install cboxdk/tap/telemetryd
```

## What is here

| Formula | |
|---|---|
| `telemetryd` | Single-binary observability backend: OTLP in, Loki/Tempo/Prometheus APIs out — [cboxdk/telemetryd](https://github.com/cboxdk/telemetryd) |

## How these are updated

Each formula is generated from a published release of the project it installs, by a
script that lives in that project's repository. It carries the release's own SHA-256
checksums, taken from the `SHA256SUMS` published alongside the binaries, and Homebrew
verifies them at install time.

Nothing here is written by hand. A formula can therefore only ever describe a build
that exists: the generator refuses to publish if the version disagrees with the tag, if
a checksum is missing, or if a placeholder survives substitution.

Releases are also signed. To check one yourself before installing, see the
[verifying a release](https://github.com/cboxdk/telemetryd/blob/main/docs/getting-started/installation.md)
section of the project's documentation.
