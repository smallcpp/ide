# Changelog

## Unreleased

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
