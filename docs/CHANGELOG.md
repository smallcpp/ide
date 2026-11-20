# Changelog

## Unreleased

A fresh configuration installs `bin/ide` to `$HOME/opt/smallcpp`.
The program is `$HOME/opt/smallcpp/bin/ide`. An absolute prefix
argument still selects another prefix for that run.

Class definitions live in `.shpp` headers. Method bodies written
outside the class are in `.scpp` files that `build` compiles and
links. No file includes a `.scpp`.

Startup was slow because the collector runs on every allocation and
scans every word of every live object. The LSP frame buffer and the
diagnostic table were collected objects, so each widget built after
them scanned that storage. Those buffers now come from `malloc`. The
file list creates a row string when the row is shown. A missing
settings file does not build the defaults a second time.

A normal `build` compiles `bin/ide` and leaves the test programs
unbuilt. `build test` builds `bin/ide` and `test-buffer`,
`test-toml`, `test-document`, `test-syntax`, `test-settings`,
`test-project`, `test-explorer`, `test-lsp`, and `test-session`,
then runs the suite.

## 0.0.1

The suite gained `test-buffer`, `test-toml`, `test-document`,
`test-syntax`, `test-settings`, `test-project`, `test-explorer`,
`test-lsp`, and `test-session`. It also checks `ide --help`,
`ide --version`, and an unknown option. The hello program test is
gone. Run the suite with `build test` after `scripts/setup`.
