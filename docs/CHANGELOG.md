# Changelog

## Unreleased

Menus call `Session::run` with a command id. The menu row stores
that id, then a tab, then the label and any stored shortcut. The
handler reads the id. Find in Project runs `find-project`. Search,
View, Project, and Build do the same, including `goto-line`,
`build-compile`, `build-build`, `build-run`, `focus-search`, and
`focus-messages`.

The window has a bottom message notebook. Search lists project
hits. Diagnostics lists the active file and the language-client
messages. Build shows the command's raw text and the lines an error
pattern parsed. Activating a row opens the file and moves the caret.

Build settings are three entries, compile, build, and run. Each
entry has a label, a command, and a working directory. One
`error_regex` is shared. A project key overrides the same user key.
An empty directory means the project root. The pattern uses `%p` for
a path, `%l` for a line, `%c` for a column, and `%*` to skip. The
default is `%p:%l:`.

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
