# ide

`ide` is a text editor written in scpp. It opens and saves files,
edits buffers, and keeps a project folder with settings, a file list,
and recovery snapshots. The window is GTK 4, through the smallcpp
wrapper.

Version 0.0.1. The repository is
https://github.com/smallcpp/ide. The compiler is
https://github.com/smallcpp/smallcpp.

`scpp` has to be on `PATH`, or installed at `$HOME/opt/smallcpp`.
When `$HOME/.config/smallcpp/config.ini` exists, `scpp` reads header
and library locations from it. A checkout of the compiler can be put
on `PATH` by adding its `bin` directory.

Use the scripts in `scripts/`. Do not run `cmake` yourself to
configure, build, or test.

```sh
scripts/setup
build
build test
../bin/ide --help
exit
```

`scripts/setup [--clean] [debug|release|profile]` configures `build/`
and starts a project shell. `build` compiles `src/ide.scpp`. `build
test` compiles the unit tests and runs them. `scripts/clean` removes
the build products. Nothing is installed. Run `bin/ide`.

What the editor does is described in
[docs/ide.md](docs/ide.md). Behavior the language or the GTK wrapper
cannot match is listed in [docs/limits.md](docs/limits.md). The coding
standard is [docs/coding-standard.md](docs/coding-standard.md).
