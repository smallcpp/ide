# ide

`ide` edits text files. It is the smallcpp editor with the same jobs
as the cedit editor: files, buffers, commands, a project folder, and
a GTK window.

Build, test, and install it with the scripts in the root `README.md`.
Do not run `cmake` yourself. `scripts/setup`, then `build`, then
`install`, then `bin/ide`. `install` copies `bin/ide` to `bin/ide`
under the prefix. A fresh configuration uses `$HOME/opt/ide`.
`install /absolute/path` selects that prefix for one run. A normal
`build` compiles the editor and leaves the test programs unbuilt.
`build test` builds those programs and runs the unit tests. Those
tests cover the buffer, files, settings, projects, the file list,
the language-client framing, and the session commands. They do not
open a window.

## Starting

```text
ide [file or folder]...
ide --help
ide --version
```

`--help` and `--version` exit 0. An unknown option exits 2 and writes
`ide: error[IDE0001]:` to stderr. A folder that contains
`.side/project.toml` opens as a project. Any other folder opens as a
plain folder. A file opens as a document. With no path, and when
`project.reopen_last` is true, the editor opens `project.last_root`
when that folder is still a project. A missing remembered project is
reported, `last_root` is cleared, and a new untitled buffer is shown.

The binary refuses a file that contains a NUL byte or invalid UTF-8
and reports `not a text file`. The open document is left as it was.
Files larger than 32 MiB are refused.

## Window

The window has File, Edit, View, Project, and Help menus, a sidebar,
document tabs, and a status line. The status line shows the title, a
dirty star, the line, the column, the language, and a diagnostic
count when the language client has reported any.

File covers New, Open, Save, Save As, Save All, Reload, Close, Close
All, Open Folder, the recent list, and Quit. Recent paths are listed
in the File menu as `Recent: path`, most recent first, up to 20.
Opening a path that is already open focuses that tab. The last tab,
when closed, is replaced by a fresh `untitled.scpp` buffer. Only Quit
and the window close button leave the program. A dirty tab asks
Save, Discard, or Cancel. An untitled buffer asks for a path. Save
As refuses a path that belongs to another open document, and it asks
before replacing a file that already exists. Save All writes modified
named documents and skips untitled ones.

Edit covers undo, redo, the editor clipboard, find and replace, go to
line, comments, indent, column edit, and two built-in plugins. Find
supports case, whole words, and in-selection search, and it wraps
once. Replace All is one undo step. Go to line accepts a line or
`line:column`. Comment toggles a line comment. Block comment is
menu-only. Insert Date writes the UTC clock time. Toggle Debug
inserts or removes `// DEBUG` at the start of the current line.

View stores line numbers, whitespace, line ends, indent markers, and
the project manager. The project manager flag shows or hides the
sidebar. The sidebar cannot be dragged to zero width. Hiding it
remembers the width. The text view itself does not draw a gutter,
whitespace glyphs, or indent guides. The line and column in the
status line are the values the editor buffer keeps.

## Projects

Project metadata is `.side/project.toml`. Workspace state is
`.side/workspace.toml`. Both are version 1. Paths inside the project
are stored relative to the root. Paths outside it are absolute.
`project.toml` is limited to 64 KiB and `workspace.toml` to 1 MiB.
Writes go to a temporary file and then rename into place, mode 0600.
A file that changed since it was read is not overwritten.

New Project writes the metadata and does not create source files. The
name defaults to the folder name. Open Project requires
`project.toml` and asks about dirty documents before it replaces the
tabs. Open Folder and New Project keep the open documents. They save
the outgoing workspace first. Close Project writes the workspace,
leaves the folder open without project settings, and clears
`last_root` when it pointed at that root. Delete Project removes the
two toml files and removes `.side` only when it is empty. A symlink
`.side` is refused. Source files are kept. Delete does not save the
workspace first.

The sidebar lists the folder. Directories come first, then a
byte-order sort. Only expanded directories are read. Symlinks are
leaves. A symlink to a text file can still be opened. A directory
whose names are not UTF-8 is reported and not listed. Show Hidden is
a checkbox and is not saved for a plain folder. Exclusions are globs.
`*` and `?` work. A pattern with no slash matches a name at any
depth. A pattern with a slash matches the path relative to the root.
A pattern must not start or end with `/` or contain `.` or `..`
segments. Excluded entries stay hidden in the list and can still be
opened with File, Open.

## Settings

User settings are `$XDG_CONFIG_HOME/smallcpp/ide.toml`, or
`$HOME/.config/smallcpp/ide.toml`. That file is not the compiler
`config.ini`. A project may also have `.side/settings.toml`. A key in
the project file overrides the user file, which overrides the
built-in default. Changing a View flag that the project already
overrides updates the project file.

Editor defaults: font family `monospace`, size 12, tab width 4,
spaces rather than tabs, line numbers on, wrap off, current line
highlight off, right margin 80. Strip trailing spaces on save is
off. Auto-close brackets and auto-indent are on. Save on tab change
and save on window-focus loss are off. Untitled buffers stay dirty.
The preferences window edits font size, tab width, spaces, brackets,
auto-indent, and the language-client command, and Apply writes them
immediately without changing the file text.

Keyboard triggers are stored and checked for conflicts. The menus run
the commands. The text view keeps GTK's own keys. A legacy
`ide-shortcuts.conf` in the working directory is read when the
settings file has no `[keyboard]` table. The first successful edit of
the map is saved into the toml file and does not rewrite the legacy
file.

## Language client and recovery

`editor.lsp_command` starts a language server. An empty command turns
it off. `clangd` is used only for C and C++ files. `cwhip-lsp` is
used only for `.cw` files. Any other command is split on spaces and
started for other languages. Plain text and Markdown are not sent.
Diagnostics are parsed from `textDocument/publishDiagnostics`, capped
at 64, shown as a status count, a foreground tag on the line, and the
first message as the view tooltip.

While a project is open, dirty named buffers are copied under
`.side/recovery/`. Restore puts that text back, still unsaved, and
deletes the snapshot. Cancel deletes the snapshot and keeps the
buffer that was loaded from disk.

## Plugins

Two plugins are compiled in. There is no dynamic loader. Insert Date
and Toggle Debug are on the Edit menu.
