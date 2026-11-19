# scripts

Helper scripts for this checkout. The root `README.md` and
`docs/ide.md` are the build, test, and install guide. Use these
scripts. Do not run `cmake` yourself for configure, build, test,
or install.

- `setup [--clean] [debug|release|profile]` configures `build/` and
  starts a project shell. `build` in that shell compiles
  `src/ide.scpp` with `scpp`. `build test` runs the suite. `--clean`
  runs `clean` first. `debug`, `release`, and `profile` select the
  CMake build type. `debug` and `profile` pass `-g` to `scpp`.
- `install [prefix]` builds `ide` and installs `bin/ide`. With no
  argument the prefix is the one selected at configuration. A fresh
  configuration uses `$HOME/opt/ide`, so the program is
  `$HOME/opt/ide/bin/ide`. A prefix argument, or `--prefix` and a
  prefix, installs to that absolute path for this run. A relative
  prefix is rejected. `clean` does not remove the installed program.
- `clean` removes `bin/`, `build/`, and `lib/`.

Run `bin/ide` in the checkout, or run `bin/ide` under the prefix
after `install`.
